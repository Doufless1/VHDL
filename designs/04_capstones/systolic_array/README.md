# INT8 systolic array — a matrix-multiply engine, verified bit-exact against NumPy

> Capstone · beyond the course: the core of an AI inference accelerator

<p align="center">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="../../../docs/images/systolic_wavefront_dark.gif">
  <img width="420" alt="Animation of the 4x4 systolic array processing one tile: a diagonal wavefront of multiply-accumulates sweeps from the top-left to the bottom-right PE, followed by finished results" src="../../../docs/images/systolic_wavefront_light.gif">
</picture>
<br><sub>One tile on the 4 × 4 array. Every frame is read from the RTL simulation
trace and checked against the systolic schedule before it is drawn.</sub>
</p>

A `ROWS` × `COLS` grid of multiply-accumulate processing elements (PEs) that computes

$$C = A\,B, \qquad A \in \mathrm{INT8}^{R \times K},\quad B \in \mathrm{INT8}^{K \times C},\quad C \in \mathrm{INT32}^{R \times C}$$

for any reduction depth K: INT8 operands, INT32 accumulation — the arithmetic of a
quantized neural-network layer.

| File | Contents |
|---|---|
| [`rtl/mac_pe.vhd`](rtl/mac_pe.vhd) | Processing element: forward A right, B down, `acc += a·b` |
| [`rtl/systolic_array.vhd`](rtl/systolic_array.vhd) | Input skew, PE grid (nested `for … generate`), tile control |
| [`tb/tb_systolic_array.vhd`](tb/tb_systolic_array.vhd) | Streams NumPy golden vectors, checks every element and the cycle count |
| [`../../../scripts/gemm_golden.py`](../../../scripts/gemm_golden.py) | NumPy golden model and vector generator |

## How it works

```
             B(k,0)   B(k,1)   B(k,2)    Beat k carries column k of A and row k of B.
               |       z^-1     z^-2     Row i of A is delayed by i cycles, column j
               v        v        v       of B by j cycles (input skew), so A(i,k) and
A(0,k) ------>PE------>PE------>PE       B(k,j) arrive at PE(i,j) together, in cycle
A(1,k) -z^-1->PE------>PE------>PE       k + i + j. Each PE keeps its partial sum
A(2,k) -z^-2->PE------>PE------>PE       C(i,j) locally: output-stationary dataflow.
```

Every operand moves one register per clock, yet each A element is used by `COLS`
PEs and each B element by `ROWS` PEs: **R·C multiply-accumulates per cycle from
only R + C operands per cycle**. That data reuse is why systolic arrays are the
workhorse of matrix engines — memory bandwidth, not arithmetic, is the scarce
resource.

### Interface (valid/ready, AXI4-Stream style)

| Port | Dir | Width | Description |
|---|---|---|---|
| `in_valid` / `in_ready` | in / out | 1 | Beat handshake; bubbles (`in_valid = '0'`) are allowed mid-tile |
| `in_last` | in | 1 | Marks beat K − 1, the end of a tile |
| `a_col` | in | `ROWS`·8 | Column k of A: `A(i,k)` in slice i |
| `b_row` | in | `COLS`·8 | Row k of B: `B(k,j)` in slice j |
| `out_valid` | out | 1 | One-cycle pulse: `c_mat` holds the result |
| `c_mat` | out | `ROWS`·`COLS`·32 | `C(i,j)` in slice `i·COLS + j` |

After the last beat the array drains with `in_ready = '0'`; `in_ready` returns in
the same cycle as `out_valid`, so the next tile can start immediately.

## Design decisions

- **No global clear signal.** A `first` tag travels through the array *with* the
  data and tells each PE to start a new sum (`acc := a·b` instead of
  `acc += a·b`). Each PE restarts exactly when its own first operand arrives, and
  there is no broadcast net fanning out to every PE — the kind of high-fanout
  signal that limits timing as arrays grow.
- **Valid tags instead of zero padding.** Bubbles in the input stream simply flow
  through as invalid beats; no PE needs to be told about them.
- **Reset only the control path.** Valid/first tags are reset; operand and
  accumulator registers are not — their values only matter when a valid tag
  accompanies them. Less reset routing, a common FPGA datapath practice.
- **INT32 accumulators sized for the worst case.** |a·b| ≤ 2<sup>14</sup> for INT8, so
  32 bits are overflow-free for any K below 2<sup>17</sup> = 131,072. The golden model
  asserts the INT32 range for every tile.
- **Output-stationary** keeps partial sums in place and needs no partial-sum
  movement. The alternatives trade differently: *weight-stationary* preloads B into
  the PEs and streams activations (the classic choice when a weight matrix is
  reused across many inputs), *input-stationary* pins A.

## Performance model

Without bubbles, a tile's result is captured **K + R + C − 1 cycles** after its first
beat, and that is also the tile period. The testbench checks this cycle count
exactly for every golden tile at every array size, so the model below is verified,
not assumed. Utilization is K / (K + R + C − 1):

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="../../../docs/images/systolic_utilization_dark.png">
  <img alt="PE utilization versus reduction depth K for 4x4, 8x8 and 16x16 arrays, with the tile depths used in the regression marked" src="../../../docs/images/systolic_utilization_light.png">
</picture>

Short dot products are dominated by pipeline fill and drain; larger arrays need
deeper K to stay busy. Peak throughput is R·C MACs per cycle — 1.6 GMAC/s for
the 4 × 4 array at an example clock of 100 MHz.

## Verification: bit-exact against a NumPy golden model

Before each simulation, VUnit calls [`gemm_golden.py`](../../../scripts/gemm_golden.py),
which writes the test vectors for that array size. The file is already in *beat
order* — exactly the stream the hardware consumes — so the testbench just streams
it and compares every result element.

The vector set (16 tiles per array size):

| Tiles | Why |
|---|---|
| K = 1 | Outer product: the shortest possible tile |
| All −128 × all −128, K = 64 | Largest positive sums (64 · 2<sup>14</sup>) |
| All −128 × all +127, K = 64 | Most negative sums |
| B = identity | C must equal A |
| Random, K ∈ {2, 3, R + C, 16, 31, 100} | Depth sweep |
| A fully-connected layer (3R × 48) · (48 × 2C) | Split into R × C output tiles, as an accelerator compiler would map a layer onto a fixed array; the script also checks that the tiles reassemble into the full product |

| Configuration | Test cases | MACs checked per test |
|---|---|---|
| 1×1, 2×2, 3×5, 4×4, 8×8 | `golden_vectors_bit_exact` — also checks the cycle count | 572 … 37,952 |
| same | `golden_vectors_with_random_bubbles` — random gaps in the stream | same |

About 118,000 multiply-accumulates are checked bit-exact in every regression run:
`python run.py "*tb_systolic_array*"`. Mutation testing checks that a PE ignoring
the `first` tag and a one-cycle skew error are both caught.

## Implementation

Yosys estimate for 4 × 4 (iCE40 mapping with hard MAC blocks): **16 MAC blocks**,
527 LUT4 + 496 carry, 824 flip-flops — the INT32 adders are the bulk of the logic.
The MAX 10 10M08 on the lab board has the embedded multipliers for 16 PEs; a
compile-only Quartus project with the 576 bits of operand and result buses as
virtual pins is in
[`quartus/`](quartus/).

## Next steps

- **Double-buffered results**: copy each accumulator out when its last product
  lands, so the next tile can enter while the previous one drains and tiles
  stream back to back (utilization approaching 100 % for long runs of tiles).
- **Requantization stage**: INT32 → INT8 with a per-tensor scale, zero point and
  ReLU, to complete a quantized layer.
- **On-board demo**: stream matrices from a PC through the
  [UART](../../03_systems/uart/) and send C back.
