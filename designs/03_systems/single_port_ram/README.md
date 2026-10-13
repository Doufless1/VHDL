# Single-port RAM — written so synthesis infers block RAM

> Course week 5 (memory)

A synchronous RAM (`DATA_WIDTH` × 2<sup>`ADDR_WIDTH`</sup>, default 64 × 8) in the
coding style synthesis tools map onto dedicated block RAM instead of thousands of
flip-flops.

| File | Contents |
|---|---|
| [`rtl/single_port_ram.vhd`](rtl/single_port_ram.vhd) | The RAM |
| [`tb/tb_single_port_ram.vhd`](tb/tb_single_port_ram.vhd) | Shadow-memory scoreboard test |

## Design notes

The address is registered and the array is read with the registered address. This
is the pattern Intel's tools recognise as a MAX 10 M9K block, and it fixes two
behaviours the user of the RAM can rely on:

- **one clock of read latency** — `dout` shows `ram(addr)` one edge after `addr`;
- **write-first** read-during-write — writing and reading the same address returns
  the new data.

## Verification

The testbench keeps its own copy of the memory and compares every read with it.

| Test case | What it checks |
|---|---|
| `power_up_contents_are_zero` | Initial contents |
| `write_all_then_read_back` | Every address, random data |
| `read_latency_is_one_clock` | A new address does **not** reach `dout` before the next clock edge |
| `read_during_write_returns_new_data` | Write-first behaviour |
| `write_enable_low_does_not_write` | `we = '0'` leaves memory unchanged |
| `random_reads_and_writes` | 5000 random accesses against the shadow memory |

`read_latency_is_one_clock` was added after **mutation testing** found a gap: a RAM
with an asynchronous read (using `addr` instead of `addr_reg`) passed every other
test, because they all sampled `dout` after the clock edge, where both versions
agree.

## Implementation

| Design | Quartus Prime 20.1, MAX 10 (original lab compile) |
|---|---|
| `single_port_ram` 64 × 8 | **1 M9K block (512 memory bits)**, 1 LE |

The open-source Yosys estimate builds this RAM from flip-flops, because the iCE40
block RAM it targets has no write-first mode; on the MAX 10 board Quartus uses one
block RAM, as the lab compile shows.
