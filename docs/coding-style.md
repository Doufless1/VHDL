# Coding style

The conventions every file in `designs/` follows, and why.

## Language

- **RTL is VHDL-93**; testbenches use **VHDL-2008**. VHDL-93 is the default of
  Quartus Prime Lite and is accepted by every synthesis tool; CI analyzes all RTL
  with `ghdl --std=93c` to keep it that way. Testbenches only run in simulators,
  where VHDL-2008 (`to_hstring`, aggregate targets, PSL) makes them shorter.
- **Arithmetic with `ieee.numeric_std`** (`unsigned`, `signed`). Never
  `std_logic_arith` / `std_logic_unsigned` — vendor packages, not IEEE standards.
  Ports stay `std_logic_vector`; conversions happen inside the architecture.
- **Direct entity instantiation** (`u_fa : entity work.full_adder`) instead of
  component declarations that repeat every port list.
- **Vendor-neutral RTL.** No vendor attributes or IP in `rtl/`; tool settings live
  in the build scripts.

## Naming

| Item | Convention | Example |
|---|---|---|
| Files | One design unit per file, named after it | `uart_tx.vhd` |
| Signals, ports | `lower_snake_case` | `tx_ready`, `bits_left` |
| Generics, constants | `UPPER_SNAKE_CASE` | `CLKS_PER_BIT` |
| Types | `_t` suffix | `state_t`, `rom_t` |
| Active-low | `_n` suffix | `oe_n`, `seg_n` |
| Instances | `u_` prefix | `u_btn_sync` |
| Asynchronous reset | `arst` | course designs |
| Synchronous reset | `rst` | new IP |

## Resets

- The course labs keep the asynchronous active-high reset the lab specification
  asked for (`arst`).
- New IP (UART, filter, systolic array) uses a **synchronous** reset: no
  reset-recovery/removal timing, and the reset can be pipelined.
- **Datapath registers are not reset** where their value is only used together with
  a valid flag (`mac_pe`); only control state is. Less reset routing, same behaviour.
- A reset coming from a button is **synchronized** before use
  ([`sync_2ff`](../designs/00_common/rtl/sync_2ff.vhd)).
- Registers whose power-up value matters declare it (`signal state : state_t :=
  CARS_GREEN;`) — the formal proof of the traffic light showed why.

## Clocking and interfaces

- One clock per design, rising edge, except where a lab asks otherwise (the
  negative-edge register).
- Every asynchronous input passes a synchronizer before logic sees it.
- Streaming interfaces use **valid/ready** (AXI4-Stream semantics): a transfer
  happens on a rising edge where both are `'1'`; a source may not wait for `ready`
  before asserting `valid`.
- Combinational processes assign every output on every path (a default assignment
  first) — otherwise synthesis infers a latch, which CI rejects.

## Comments

Every file starts with a header block saying what the unit does and the decisions
behind it — the *why*, not a restatement of the code. Generics and ports get a
short comment when the name alone does not say the unit or polarity. ASCII only
(VHDL-93 source is ISO-8859-1).
