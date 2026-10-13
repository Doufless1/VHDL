# D register — negative-edge flip-flops with asynchronous reset

> Course week 3 · sequential logic · board-proven

A `WIDTH`-bit register of D flip-flops that captures on the **falling** clock edge
(a lab requirement) and clears on an asynchronous, active-high reset.

| File | Contents |
|---|---|
| [`rtl/d_register.vhd`](rtl/d_register.vhd) | The register (`WIDTH` generic, default 8) |
| [`tb/tb_d_register.vhd`](tb/tb_d_register.vhd) | Self-checking test, OSVVM random data |
| [`quartus/`](quartus/) | Board build: `WIDTH = 6`, clocked from a push button |

## A bug that was really a board constraint

The lab file was called `d_flip_flop_8bit` and its comments said "8-bit", but the
ports were 6 bits wide. The original pin report explains why: the lab board has
six free switches and LEDs for this exercise. The fix is a generic: the RTL
defaults to a byte, and the board build sets `WIDTH = 6` from its Quartus script.

## Verification

| Test case | What it checks |
|---|---|
| `captures_on_falling_edge_only` | `d` changed right after a falling edge is **not** loaded by the next rising edge, and **is** loaded by the next falling edge |
| `async_reset_without_clock` | With the clock stopped completely, reset still clears `q` |
| `reset_dominates_clock` | Clock edges are ignored while reset is held |
| `random_data_1000_cycles` | 1000 random words, each checked after its capture edge |

Run at `WIDTH` = 6 (board) and 8: `python run.py "*tb_d_register*"`.

The first version of `captures_on_falling_edge_only` contained a check that could
never fail. It was found by re-reading the test, rewritten, and confirmed by
**mutation**: a rising-edge register now fails two of the four tests (this mutant is
part of `scripts/mutation_test.py`).

## Implementation

| Design | Quartus Prime 20.1, MAX 10 (original lab compile) | Yosys estimate, current RTL |
|---|---|---|
| `d_register` (`WIDTH = 6`) | 7 LEs, 6 registers | 6 flip-flops |
