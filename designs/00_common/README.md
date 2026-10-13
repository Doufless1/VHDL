# Common primitives

Small building blocks shared by several designs.

## `sync_2ff` — clock-domain-crossing synchronizer

[`rtl/sync_2ff.vhd`](rtl/sync_2ff.vhd) brings one asynchronous bit (a push
button, a UART receive pin, a reset button) into the clock domain of `clk`.

```
async_in ──►[FF]──►[FF]──► sync_out
              ▲      ▲
clk ──────────┴──────┘
```

The first flip-flop samples a signal that can change at any moment relative to
the clock, so it can go **metastable**. The second stage gives it a full clock
period to settle before any logic sees the value. `STAGES` adds more stages for
very high clock rates.

| Generic | Default | Meaning |
|---|---|---|
| `STAGES` | 2 | Flip-flops in the chain (at least 2) |
| `INIT` | `'0'` | Power-up value, e.g. `'1'` for an idle-high UART line |

Design decisions:

- **Single bits only.** A multi-bit bus must never cross through per-bit
  synchronizers: the bits can be captured in different cycles and the receiver
  sees a value that never existed. Buses cross with a handshake or an
  asynchronous FIFO.
- **No reset on the chain.** The synchronizer must not depend on a signal that is
  itself asynchronous; `INIT` defines the power-up value instead.
- **Vendor-neutral RTL.** Tool-specific settings (Quartus
  `SYNCHRONIZER_IDENTIFICATION`) live in the build scripts, not in the VHDL.

Used by: [`uart_rx`](../03_systems/uart/rtl/uart_rx.vhd) (serial input),
[`serial_text_transmitter`](../03_systems/uart/rtl/serial_text_transmitter.vhd)
(reset button) and
[`traffic_light_controller`](../03_systems/traffic_light/rtl/traffic_light_controller.vhd)
(pedestrian button). It is exercised by their test benches.
