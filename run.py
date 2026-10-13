#!/usr/bin/env python3
"""Regression runner for every design in this repository (VUnit + GHDL).

    python run.py                 # compile everything, run all test cases
    python run.py -p 4            # ... 4 simulations in parallel
    python run.py "*uart*"        # only test cases matching a pattern
    python run.py --list          # list all test cases
    python run.py --gui <test>    # open one test in GTKWave

Each test bench is self-checking: it fails on the first mismatch against its
reference model. Several test benches are run in more than one configuration
(generics sweep), e.g. the systolic array at five array sizes, each checked
against freshly generated NumPy golden vectors.
"""

import os
import shutil
import sys
from pathlib import Path

from vunit import VUnit

ROOT = Path(__file__).resolve().parent
DESIGNS = ROOT / "designs"
SIM_DATA = ROOT / "build" / "sim_data"          # CSVs exported for the figures

sys.path.insert(0, str(ROOT / "scripts"))
import gemm_golden  # noqa: E402  (NumPy golden model for the systolic array)

vu = VUnit.from_argv(compile_builtins=False)
vu.add_vhdl_builtins()
vu.add_osvvm()                                   # OSVVM RandomPkg for stimulus

lib = vu.add_library("lib")
lib.add_source_files(DESIGNS / "**" / "rtl" / "*.vhd")
lib.add_source_files(DESIGNS / "**" / "tb" / "*.vhd")

# Optional waveform dump for a single test:  WAVE=path/to/file.vcd python run.py <test>
if os.environ.get("WAVE"):
    lib.set_sim_option("ghdl.sim_flags", [f"--vcd={Path(os.environ['WAVE']).resolve()}"])


def export(csv_name: str, target: str):
    """post_check hook: copy a CSV written by the test bench to build/sim_data/."""

    def post_check(output_path):
        source = Path(output_path) / csv_name
        if source.exists():
            SIM_DATA.mkdir(parents=True, exist_ok=True)
            shutil.copy(source, SIM_DATA / target)
        return True

    return post_check


def golden_vectors(rows: int, cols: int, seed: int):
    """pre_config hook: write NumPy golden vectors next to the simulation."""

    def pre_config(output_path):
        gemm_golden.write_vectors(Path(output_path) / "gemm_vectors.txt", rows, cols, seed)
        return True

    return pre_config


# --- 01 combinational -------------------------------------------------------
tb = lib.test_bench("tb_adders")
for width in (1, 3, 8):                          # 3 = the lab design, 8 = 131k vectors
    tb.add_config(name=f"width_{width}", generics={"WIDTH": width})

# --- 02 sequential ----------------------------------------------------------
tb = lib.test_bench("tb_d_register")
for width in (6, 8):                             # 6 = board build, 8 = default
    tb.add_config(name=f"width_{width}", generics={"WIDTH": width})

tb = lib.test_bench("tb_up_down_counter")
for width in (3, 8):
    tb.add_config(name=f"width_{width}", generics={"WIDTH": width})

# --- 03 systems -------------------------------------------------------------
for name in ("tb_uart_tx", "tb_uart_rx"):
    tb = lib.test_bench(name)
    tb.add_config(name="fast", generics={"CLK_FREQ": 10_000_000, "BAUD": 1_000_000})
    tb.add_config(name="board", generics={"CLK_FREQ": 50_000_000, "BAUD": 9_600, "BYTES_PER_TEST": 12})

# --- 04 capstones -----------------------------------------------------------
tb = lib.test_bench("tb_moving_average")
for log2_taps in (0, 3, 5):                      # N = 1 (pass-through), 8, 32
    tb.add_config(
        name=f"taps_{2**log2_taps}",
        generics={"DATA_WIDTH": 12, "LOG2_TAPS": log2_taps},
        post_check=export("samples.csv", f"moving_average_taps_{2**log2_taps}.csv"),
    )

tb = lib.test_bench("tb_systolic_array")
for rows, cols in ((1, 1), (2, 2), (3, 5), (4, 4), (8, 8)):
    tb.add_config(
        name=f"{rows}x{cols}",
        generics={"ROWS": rows, "COLS": cols},
        pre_config=golden_vectors(rows, cols, seed=100 * rows + cols),
    )

vu.main()
