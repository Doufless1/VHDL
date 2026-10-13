# Adders — from gate equations to a generic ripple-carry adder

> Course weeks 1–2 · combinational logic · board-proven on the MAX 10 lab board

The first two labs of the course: a 2-bit adder written as boolean equations, then
a 3-bit adder built structurally from full-adder components. The second one is now
generic in its width.

| File | Contents |
|---|---|
| [`rtl/two_bit_adder.vhd`](rtl/two_bit_adder.vhd) | Week-1 lab: 2-bit adder as gate equations (course template by J.S.D. Stokkink) |
| [`rtl/full_adder.vhd`](rtl/full_adder.vhd) | 1-bit full adder |
| [`rtl/ripple_carry_adder.vhd`](rtl/ripple_carry_adder.vhd) | `WIDTH`-bit adder: `for … generate` over full adders (`WIDTH = 3` is the week-2 lab) |
| [`tb/tb_adders.vhd`](tb/tb_adders.vhd) | Exhaustive self-checking test of all three |
| [`quartus/`](quartus/) | Board projects with the original pin assignments |

## Interface — `ripple_carry_adder`

| Port | Dir | Width | Description |
|---|---|---|---|
| `a`, `b` | in | `WIDTH` | Operands (unsigned) |
| `cin` | in | 1 | Carry in |
| `sum` | out | `WIDTH` | `a + b + cin` modulo 2<sup>WIDTH</sup> |
| `cout` | out | 1 | Carry out |

## Design notes

```
 cin ─►[FA 0]─carry(1)─►[FA 1]─carry(2)─► … ─►[FA W-1]─► cout
         │                 │                     │
       sum(0)            sum(1)              sum(W-1)
```

- The carry ripples through every stage, so the critical path grows linearly with
  `WIDTH`. That is fine for a few bits; for wide adders, `a + b` with
  `numeric_std` lets the synthesis tool use the FPGA's dedicated carry chain.
- The week-2 lab used a component declaration plus a configuration line; the
  refactor uses direct entity instantiation (`entity work.full_adder`), which
  needs no duplicated port list.

## Verification

Every possible input is applied and compared with integer addition:

| Test case | Vectors |
|---|---|
| `full_adder_exhaustive` | 8 |
| `two_bit_adder_exhaustive` | 16 |
| `ripple_carry_adder_exhaustive` | 2<sup>2·WIDTH+1</sup>: 8 / 128 / **131,072** for `WIDTH` = 1 / 3 / 8 |

`run.py` runs the bench at `WIDTH` = 1, 3 and 8:
`python run.py "*tb_adders*"`. Mutation testing checks that a wrong carry equation
and a broken carry chain are both caught.

## Implementation

| Design | Quartus Prime 20.1, MAX 10 (original lab compile) | Yosys estimate, current RTL |
|---|---|---|
| `two_bit_adder` | 4 LEs | 3 LUT4 |
| `ripple_carry_adder` (`WIDTH = 3`) | 7 LEs | 6 LUT4 |

Board build: `quartus_sh -t designs/01_combinational/adders/quartus/ripple_carry_adder.tcl`
(operands on switches, sum and carry on LEDs).
