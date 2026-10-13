#!/usr/bin/env python3
"""Mutation testing: verify that the testbenches actually catch bugs.

A passing regression only proves something if the tests would fail on a
broken design. This script injects realistic bugs ("mutants") into the RTL one
at a time - a wrong constant, a swapped condition, an off-by-one - runs the
relevant tests, and checks that at least one of them fails ("kills" the
mutant). The original file is always restored.

    python scripts/mutation_test.py            # all mutants
    python scripts/mutation_test.py -k uart    # mutants whose name contains 'uart'
"""

from __future__ import annotations

import argparse
import subprocess
import sys
import time
from dataclasses import dataclass
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "build" / "vunit_mutation"


@dataclass
class Mutant:
    name: str
    file: str            # relative to designs/
    original: str        # exact text to replace (must occur once)
    mutated: str
    tests: str           # VUnit test pattern that must catch it


MUTANTS = [
    Mutant("full adder: carry uses OR instead of AND",
           "01_combinational/adders/rtl/full_adder.vhd",
           "cout <= (a and b) or (cin and (a xor b));",
           "cout <= (a or b) or (cin and (a xor b));", "*tb_adders*"),
    Mutant("ripple-carry adder: carry chain broken at bit 0",
           "01_combinational/adders/rtl/ripple_carry_adder.vhd",
           "carry(0) <= cin;", "carry(0) <= '0';", "*tb_adders*"),
    Mutant("mux: inputs 1 and 2 swapped",
           "01_combinational/data_routing/rtl/mux_4to1.vhd",
           'when "01"   => y <= d1;', 'when "01"   => y <= d2;', "*tb_data_routing*"),
    Mutant("decoder: wrong one-hot code for input 3",
           "01_combinational/data_routing/rtl/decoder_2to4.vhd",
           'when "11"   => y <= "1000";', 'when "11"   => y <= "0100";', "*tb_data_routing*"),
    Mutant("seven-segment: typo in the pattern for 9",
           "01_combinational/seven_segment/rtl/seven_segment_decoder.vhd",
           'when "1001" => lit <= "1111011";', 'when "1001" => lit <= "1110011";', "*tb_seven_segment*"),
    Mutant("parity: odd instead of even parity",
           "01_combinational/seven_segment/rtl/even_parity.vhd",
           "p := '0';", "p := '1';", "*tb_seven_segment*"),
    Mutant("register: captures on the rising edge",
           "02_sequential/d_register/rtl/d_register.vhd",
           "elsif falling_edge(clk) then", "elsif rising_edge(clk) then", "*tb_d_register*"),
    Mutant("counter: direction inverted",
           "02_sequential/up_down_counter/rtl/up_down_counter.vhd",
           "if up_down = '1' then", "if up_down = '0' then", "*tb_up_down_counter*"),
    Mutant("traffic light: green jumps straight to red",
           "03_systems/traffic_light/rtl/traffic_light_controller.vhd",
           "            state   <= CARS_ORANGE;", "            state   <= CARS_RED;", "*tb_traffic_light*"),
    Mutant("traffic light: request never cleared",
           "03_systems/traffic_light/rtl/traffic_light_controller.vhd",
           "            request <= '0';\n", "            request <= '1';\n", "*tb_traffic_light*"),
    Mutant("PIC16 ALU: SUBWF carry reports borrow instead of no-borrow",
           "03_systems/pic16_alu/rtl/pic16_alu.vhd",
           """            add := pic_add(f, not w, '1');
            res := add(7 downto 0);  v_c := add(8);""",
           """            add := pic_add(f, not w, '1');
            res := add(7 downto 0);  v_c := not add(8);""", "*tb_pic16_alu*"),
    Mutant("PIC16 ALU: RLF ignores the carry input",
           "03_systems/pic16_alu/rtl/pic16_alu.vhd",
           "res   := f(6 downto 0) & c_in;", "res   := f(6 downto 0) & '0';", "*tb_pic16_alu*"),
    Mutant("RAM: read uses the unregistered address",
           "03_systems/single_port_ram/rtl/single_port_ram.vhd",
           "dout <= ram(to_integer(unsigned(addr_reg)));",
           "dout <= ram(to_integer(unsigned(addr)));", "*tb_single_port_ram*"),
    Mutant("UART TX: bit time one clock short",
           "03_systems/uart/rtl/uart_tx.vhd",
           "elsif baud_cnt /= CLKS_PER_BIT - 1 then", "elsif baud_cnt /= CLKS_PER_BIT - 2 then",
           "*tb_uart_tx.fast*"),
    Mutant("UART TX: stop bit sent as 0",
           "03_systems/uart/rtl/uart_tx.vhd",
           "shreg     <= '1' & tx_data;", "shreg     <= '0' & tx_data;", "*tb_uart_tx.fast*"),
    Mutant("UART RX: samples at the start of each bit, not the centre",
           "03_systems/uart/rtl/uart_rx.vhd",
           "constant HALF_BIT     : positive := CLKS_PER_BIT / 2;",
           "constant HALF_BIT     : positive := 1;", "*tb_uart_rx.fast*"),
    Mutant("moving average: oldest sample never subtracted",
           "04_capstones/moving_average_filter/rtl/moving_average.vhd",
           "acc <= acc + resize(x_new, ACC_WIDTH) - resize(x_old, ACC_WIDTH);",
           "acc <= acc + resize(x_new, ACC_WIDTH);", "*tb_moving_average.taps_8*"),
    Mutant("moving average: delay line one tap short",
           "04_capstones/moving_average_filter/rtl/moving_average.vhd",
           "x_old := delay(TAPS - 1);", "x_old := delay(TAPS - 2);", "*tb_moving_average.taps_8*"),
    Mutant("systolic array: PE ignores the first tag",
           "04_capstones/systolic_array/rtl/mac_pe.vhd",
           "if first_in = '1' then", "if false then", "*tb_systolic_array.4x4*"),
    Mutant("systolic array: B operands one cycle early",
           "04_capstones/systolic_array/rtl/systolic_array.vhd",
           "    b_v(0, j) <= data_pipe(j);",
           "    b_v(0, j) <= data_pipe(j - 1) when j > 0 else data_pipe(0);",
           "*tb_systolic_array.4x4*"),
]


def run_tests(pattern: str) -> tuple[bool, list[str]]:
    """Run the matching tests; returns (all passed, names of failing tests)."""
    cmd = [sys.executable, str(ROOT / "run.py"), pattern, "-p", "4", "-o", str(OUTPUT), "--no-color"]
    out = subprocess.run(cmd, capture_output=True, text=True, cwd=ROOT).stdout
    failed = [line.split()[-3] for line in out.splitlines()
              if line.startswith("fail (") and len(line.split()) >= 3]
    return "All passed!" in out, failed


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("-k", default="", help="only mutants whose name contains this text")
    args = parser.parse_args()
    mutants = [m for m in MUTANTS if args.k.lower() in m.name.lower()]

    print("Baseline: the unmodified designs must pass ...", flush=True)
    passed, failed = run_tests("*")
    if not passed:
        sys.exit(f"baseline regression fails ({', '.join(failed)}): fix that first")

    killed = 0
    for i, m in enumerate(mutants, 1):
        path = ROOT / "designs" / m.file
        source = path.read_text()
        assert source.count(m.original) == 1, f"'{m.name}': original text must occur exactly once"
        start = time.time()
        try:
            path.write_text(source.replace(m.original, m.mutated))
            passed, failed = run_tests(m.tests)
        finally:
            path.write_text(source)
        killed += not passed
        verdict = "KILLED  " if not passed else "SURVIVED"
        by = f" by {failed[0]}" + (f" (+{len(failed) - 1})" if len(failed) > 1 else "") if failed else ""
        print(f"[{i:2}/{len(mutants)}] {verdict} {m.name}{by}  ({time.time() - start:.0f} s)", flush=True)

    print(f"\nMutation score: {killed}/{len(mutants)} mutants killed")
    return 0 if killed == len(mutants) else 1


if __name__ == "__main__":
    sys.exit(main())
