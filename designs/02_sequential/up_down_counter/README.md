# Up/down counter

> Course week 4 · sequential logic

A `WIDTH`-bit synchronous binary counter with count enable, direction control and
an asynchronous reset. Wraps modulo 2<sup>WIDTH</sup> in both directions.

| File | Contents |
|---|---|
| [`rtl/up_down_counter.vhd`](rtl/up_down_counter.vhd) | The counter (`WIDTH` generic, default 8) |
| [`tb/tb_up_down_counter.vhd`](tb/tb_up_down_counter.vhd) | Self-checking test against a reference model |

| Port | Dir | Width | Description |
|---|---|---|---|
| `clk` | in | 1 | Clock, rising edge |
| `arst` | in | 1 | Asynchronous reset to zero, active high |
| `enable` | in | 1 | Count when `'1'`, hold when `'0'` |
| `up_down` | in | 1 | `'1'` counts up, `'0'` counts down |
| `count` | out | `WIDTH` | Counter value |

## `numeric_std` instead of `std_logic_arith`

The course slides (and the lab version) used `ieee.std_logic_arith` and
`ieee.std_logic_unsigned`. Despite the `ieee` prefix these are **not** IEEE
standards: they are old Synopsys packages that conflict with each other and with
`numeric_std` (GHDL only accepts them with `-fsynopsys`). The counter now keeps its
state as `unsigned` from `ieee.numeric_std` and converts to `std_logic_vector`
only at the port.

## Verification

The reference model is an integer that is incremented or decremented modulo
2<sup>WIDTH</sup>; it is compared with `count` every cycle.

| Test case | What it checks |
|---|---|
| `counts_up_and_wraps` / `counts_down_and_wraps` | 2<sup>WIDTH</sup> + 3 cycles, through the wrap-around |
| `disabled_counter_holds` | `enable = '0'` freezes the value whatever `up_down` does |
| `random_against_model` | 5000 cycles of random `enable` / `up_down` |
| `async_reset_mid_count` | Reset between clock edges clears immediately |

Run at `WIDTH` = 3 and 8: `python run.py "*tb_up_down_counter*"`.

## Implementation

| Design | Quartus Prime 20.1, MAX 10 (original lab compile) | Yosys estimate, current RTL |
|---|---|---|
| `up_down_counter` (8 bit) | 9 LEs, 8 registers | 21 LUT4 + 12 carry, 8 flip-flops |
