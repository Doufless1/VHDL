# Seven-segment display with parity — hierarchy in practice

> Course weeks 2 and 6 · combinational logic + hierarchy · board-proven

Four switches are shown as a hex digit (0–F) on a common-anode 7-segment display —
or, with a select switch, their even-parity bit. Two reusable blocks wired together
by a structural top level.

| File | Contents |
|---|---|
| [`rtl/seven_segment_decoder.vhd`](rtl/seven_segment_decoder.vhd) | Hex → segments, `ACTIVE_LOW` generic |
| [`rtl/even_parity.vhd`](rtl/even_parity.vhd) | `WIDTH`-bit even-parity generator (XOR reduction) |
| [`rtl/parity_display_top.vhd`](rtl/parity_display_top.vhd) | Structural top level: parity → mux → decoder |
| [`tb/tb_seven_segment.vhd`](tb/tb_seven_segment.vhd) | Self-checking test, renders the digits as ASCII art |

```
   a ──┬──────────────────────┐
       │                    ┌─┴─────┐    ┌───────────────┐
       └──► even_parity ───►│  mux  │───►│ seven_segment │───► seg_n
                            └───────┘    │   _decoder    │
            show_parity ────────┘        └───────────────┘
```

## Verification

The expected patterns are written as an **independent spec** — the lit segments as
letters, e.g. `"-bc----"` for 1 — not copied from the RTL's bit table, so a typo in
either place shows up. The test also renders the decoder output in the log:

```
 _       _   _       _   _   _   _   _   _       _       _   _
| |   |  _|  _| |_| |_  |_    | |_| |_| |_| |_  |    _| |_  |_
|_|   | |_   _|   |  _| |_|   | |_|  _| | | |_| |_  |_| |_  |
```

| Test case | What it checks |
|---|---|
| `decoder_matches_segment_spec` | All 16 digits, active-high and active-low variants |
| `even_parity_all_inputs` | Data plus parity bit always holds an even number of ones |
| `top_shows_value_or_parity` | Both display modes for all 16 switch settings |

`python run.py "*tb_seven_segment*"`. Mutation testing checks that a one-segment
typo in the digit 9 and an odd-instead-of-even parity are caught.

## Changes from the lab version

The lab top level contained leftover chat-assistant comments (`-- ✅ FIXED: …`)
and lived in Quartus' `output_files/` folder; the segment outputs are now one
`seg_n` vector and the decoder has an `ACTIVE_LOW` generic instead of hard-wired
inverters.

## Implementation

| Design | Quartus Prime 20.1, MAX 10 (original lab compile) | Yosys estimate, current RTL |
|---|---|---|
| `parity_display_top` | 16 LEs | 23 LUT4 |

Board build (pins from the original lab compile):
`quartus_sh -t designs/01_combinational/seven_segment/quartus/parity_display_top.tcl`.
