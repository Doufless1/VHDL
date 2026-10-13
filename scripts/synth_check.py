#!/usr/bin/env python3
"""Synthesis check for every RTL top level (GHDL synthesis + Yosys).

1. Synthesizability + latch gate: every top is synthesized with
   `ghdl --synth`. GHDL refuses to infer latches, so an accidental latch fails
   this step. latch_inferred (the deliberate lab demo) must fail without
   --latches - this proves the gate works - and is then built with it.
2. Resource estimate (--report): Yosys maps each design to a plain LUT4 +
   carry-chain FPGA with hard multiply-accumulate blocks (iCE40 UltraPlus,
   synth_ice40 -dsp) - architecturally close to the MAX 10 logic element -
   and prints a Markdown table. Useful for comparing designs and spotting
   regressions; MAX 10 sign-off numbers come from Quartus.

    python scripts/synth_check.py              # gate only
    python scripts/synth_check.py --report     # gate + resource table
"""

from __future__ import annotations

import argparse
import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RTL = sorted(ROOT.glob("designs/**/rtl/*.vhd"))

# top level -> generics (the board / default configuration)
TOPS: dict[str, dict[str, int]] = {
    "two_bit_adder": {},
    "ripple_carry_adder": {"WIDTH": 3},
    "mux_4to1": {},
    "demux_1to4": {},
    "decoder_2to4": {},
    "tristate_buffer": {},
    "parity_display_top": {},
    "d_register": {"WIDTH": 6},
    "latch_free": {},
    "up_down_counter": {},
    "traffic_light_controller": {},
    "pic16_alu": {},
    "single_port_ram": {},
    "uart_tx": {},
    "uart_rx": {},
    "serial_text_transmitter": {},
    "moving_average": {},
    "systolic_array": {"ROWS": 4, "COLS": 4},
}
EXPECTED_LATCHES = {"latch_inferred"}


def ghdl_synth(work: Path, top: str, generics: dict[str, int], latches: bool = False) -> subprocess.CompletedProcess:
    cmd = ["ghdl", "--synth", "--std=08", f"--workdir={work}", "--out=none"]
    cmd += [f"-g{k}={v}" for k, v in generics.items()]
    cmd += ["--latches"] if latches else []
    return subprocess.run(cmd + [top], capture_output=True, text=True)


def ghdl_prefix() -> str:
    out = subprocess.run(["ghdl", "--dispconfig"], capture_output=True, text=True).stdout
    match = re.search(r"^library prefix:\s*(\S+)", out, re.MULTILINE)
    return os.environ.get("GHDL_PREFIX", match.group(1) if match else "")


def yosys_resources(top: str, generics: dict[str, int]) -> dict[str, int]:
    gens = " ".join(f"-g{k}={v}" for k, v in generics.items())
    files = " ".join(str(f) for f in RTL)
    with tempfile.TemporaryDirectory() as tmp:
        stat = Path(tmp) / "stat.txt"
        script = f"ghdl --std=08 {gens} {files} -e {top}; synth_ice40 -dsp -top {top}; tee -q -o {stat} stat"
        env = dict(os.environ, GHDL_PREFIX=ghdl_prefix())
        subprocess.run(["yosys", "-m", "ghdl", "-q", "-p", script], capture_output=True, env=env, check=True)
        text = stat.read_text()
    count = lambda cell: sum(int(n) for n in re.findall(rf"^\s+{cell}\s+(\d+)", text, re.MULTILINE))
    return {
        "LUT4": count("SB_LUT4"),
        "carry": count("SB_CARRY"),
        "FF": count(r"SB_DFF\w*"),
        "MAC": count("SB_MAC16"),
        "RAM": count("SB_RAM40_4K"),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--report", action="store_true", help="also print a Yosys resource table")
    args = parser.parse_args()

    ok = True
    with tempfile.TemporaryDirectory() as tmp:
        work = Path(tmp)
        # import all files, then let `ghdl -m` analyze each top in dependency order
        subprocess.run(["ghdl", "-i", "--std=08", f"--workdir={work}", *map(str, RTL)], check=True)
        for top in [*TOPS, *EXPECTED_LATCHES]:
            subprocess.run(["ghdl", "-m", "--std=08", f"--workdir={work}", top],
                           capture_output=True, cwd=work, check=True)

        for top, generics in TOPS.items():
            result = ghdl_synth(work, top, generics)
            passed = result.returncode == 0
            ok &= passed
            print(f"{'PASS' if passed else 'FAIL'}  {top}")
            if not passed:
                print("      " + result.stderr.strip().replace("\n", "\n      "))

        for top in sorted(EXPECTED_LATCHES):
            rejected = ghdl_synth(work, top, {}).returncode != 0
            allowed = ghdl_synth(work, top, {}, latches=True).returncode == 0
            ok &= rejected and allowed
            print(f"{'PASS' if rejected and allowed else 'FAIL'}  {top} "
                  "(intentional latch: rejected by default, builds with --latches)")

    print("Synthesis check passed." if ok else "Synthesis check FAILED.")

    if args.report and ok:
        print("\n| Design | LUT4 | Carry | Flip-flops | MAC blocks | 4 kbit RAM |")
        print("|---|---:|---:|---:|---:|---:|")
        for top, generics in TOPS.items():
            r = yosys_resources(top, generics)
            label = top + "".join(f" {k}={v}" for k, v in generics.items())
            print(f"| `{label}` | {r['LUT4']} | {r['carry']} | {r['FF']} | {r['MAC']} | {r['RAM']} |")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
