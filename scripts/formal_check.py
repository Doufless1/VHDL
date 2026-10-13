#!/usr/bin/env python3
"""Formal verification: prove the PSL properties of every harness in formal/.

For each harness, the GHDL plugin of Yosys turns RTL + PSL properties into a
transition system, and yosys-smtbmc (Z3) runs

  1. base case  - bounded model check from power-up for DEPTH cycles
  2. induction  - k-induction with the same depth

Both passing proves the properties for every input sequence, forever.
Exit status is non-zero if any proof fails.

    python scripts/formal_check.py              # all harnesses
    python scripts/formal_check.py uart_tx      # one harness
    python scripts/formal_check.py --depth 40
"""

from __future__ import annotations

import argparse
import os
import re
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BUILD = ROOT / "build" / "formal"

HARNESSES = {
    "traffic_light": {
        "top": "traffic_light_formal",
        "sources": [
            "designs/00_common/rtl/sync_2ff.vhd",
            "designs/03_systems/traffic_light/rtl/traffic_light_controller.vhd",
            "formal/traffic_light/traffic_light_formal.vhd",
        ],
    },
    "uart_tx": {
        "top": "uart_tx_formal",
        "sources": [
            "designs/03_systems/uart/rtl/uart_tx.vhd",
            "formal/uart_tx/uart_tx_formal.vhd",
        ],
    },
}


def ghdl_library_prefix() -> str:
    """The Yosys GHDL plugin needs GHDL_PREFIX to find the IEEE libraries."""
    if "GHDL_PREFIX" in os.environ:
        return os.environ["GHDL_PREFIX"]
    out = subprocess.run(["ghdl", "--dispconfig"], capture_output=True, text=True, check=True).stdout
    match = re.search(r"^library prefix:\s*(\S+)", out, re.MULTILINE)
    if not match:
        sys.exit("cannot determine the GHDL library prefix from 'ghdl --dispconfig'")
    return match.group(1)


def build_model(name: str, spec: dict, env: dict) -> Path:
    BUILD.mkdir(parents=True, exist_ok=True)
    smt2 = BUILD / f"{name}.smt2"
    sources = " ".join(str(ROOT / s) for s in spec["sources"])
    script = (
        f"ghdl --std=08 {sources} -e {spec['top']}; "
        f"prep -top {spec['top']}; "
        # GHDL gives every PSL assertion an enable flip-flop that only ever
        # holds its initial '1'. Folding it into a constant keeps k-induction
        # from starting with an assertion switched off.
        "opt_dff; "
        "async2sync; dffunmap; "
        f"write_smt2 -wires {smt2}"
    )
    result = subprocess.run(["yosys", "-m", "ghdl", "-q", "-p", script],
                            capture_output=True, text=True, env=env)
    if result.returncode != 0:
        sys.exit(f"[{name}] yosys failed:\n{result.stdout}\n{result.stderr}")
    return smt2


def smtbmc(smt2: Path, depth: int, induction: bool) -> tuple[bool, str]:
    cmd = ["yosys-smtbmc", "-s", "z3", "-t", str(depth)]
    cmd += ["-i"] if induction else ["--presat"]
    trace = smt2.with_suffix(".induction.vcd" if induction else ".bmc.vcd")
    cmd += ["--dump-vcd", str(trace), str(smt2)]
    out = subprocess.run(cmd, capture_output=True, text=True).stdout
    passed = "Status: PASSED" in out
    failed = re.findall(r"Assert failed in \S+: (\S+)", out)
    detail = "" if passed else f"  failed: {', '.join(failed) or 'see log'} (trace: {trace})"
    return passed, detail


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("harness", nargs="*", help=f"subset of: {', '.join(HARNESSES)}")
    parser.add_argument("--depth", type=int, default=30, help="BMC / induction depth")
    args = parser.parse_args()
    unknown = set(args.harness) - set(HARNESSES)
    if unknown:
        parser.error(f"unknown harness: {', '.join(sorted(unknown))}")

    env = dict(os.environ, GHDL_PREFIX=ghdl_library_prefix())
    ok = True
    for name in args.harness or HARNESSES:
        start = time.time()
        smt2 = build_model(name, HARNESSES[name], env)
        for step, induction in (("base case", False), ("induction", True)):
            passed, detail = smtbmc(smt2, args.depth, induction)
            ok &= passed
            print(f"{name:15} {step:10} {'PASS' if passed else 'FAIL'}{detail}")
        print(f"{name:15} {'':10} ({time.time() - start:.1f} s, depth {args.depth})")
    print("All properties proven." if ok else "Some proofs FAILED.")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
