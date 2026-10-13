# Data routing — multiplexer, demultiplexer, decoder, tri-state buffer

> Course week 3 · combinational logic · the demultiplexer is board-proven

Four ways of steering data, each written in a different VHDL style on purpose:

| File | Block | VHDL style |
|---|---|---|
| [`rtl/mux_4to1.vhd`](rtl/mux_4to1.vhd) | 4-to-1 multiplexer | process with `case` |
| [`rtl/demux_1to4.vhd`](rtl/demux_1to4.vhd) | 1-to-4 demultiplexer | concurrent `when … else` |
| [`rtl/decoder_2to4.vhd`](rtl/decoder_2to4.vhd) | binary → one-hot decoder | process with `case` |
| [`rtl/tristate_buffer.vhd`](rtl/tristate_buffer.vhd) | `WIDTH`-bit tri-state bus driver | conditional assignment with `'Z'` |
| [`tb/tb_data_routing.vhd`](tb/tb_data_routing.vhd) | self-checking test of all four | |

## Design notes

- **`when others`** in every `case`: `std_logic` has nine values (`'U'`, `'X'`,
  `'Z'`, …). Covering them keeps simulation deterministic; in hardware they never
  occur.
- **Tri-states belong at the pins.** FPGA fabric has no internal tri-state
  buses, so `tristate_buffer` is meant for a top-level `inout` pin. Two enabled
  drivers with different data is *bus contention*: `'X'` in simulation, a short
  circuit on a real bus.

## Verification

| Test case | What it checks |
|---|---|
| `mux_4to1_exhaustive` | All 16 data patterns × 4 selects |
| `demux_1to4_exhaustive` | The selected output carries `d`, all others are `'0'` |
| `demux_then_mux_is_identity` | `mux(demux(d, s), s) = d` — a property instead of a table |
| `decoder_2to4_is_one_hot` | Exactly one output active, at the right position |
| `tristate_bus_sharing` | Two buffers and a pull-up on one bus: released → `'H'`, one driver → its value, both → `'X'` exactly on the bits that disagree |

`python run.py "*tb_data_routing*"`. Mutation testing checks that swapped mux
inputs and a wrong decoder code are caught.

## Implementation

| Design | Quartus Prime 20.1, MAX 10 (original lab compile) | Yosys estimate, current RTL |
|---|---|---|
| `demux_1to4` | 5 LEs | 4 LUT4 |
| `decoder_2to4` | 5 LEs | 4 LUT4 |
| `tristate_buffer` (8 bit) | 1 LE + 8 tri-state I/O | 1 LUT4 |

Board build of the demultiplexer (pins from the original lab compile):
`quartus_sh -t designs/01_combinational/data_routing/quartus/demux_1to4.tcl`.
