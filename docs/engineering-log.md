# Engineering log

Every defect found while turning the course labs into this repository — what it
was, the evidence, and the fix. Reading other people's (and your own) old code
critically is most of the job; this log is that work made visible.

## Found by auditing the original lab repository

| # | Finding | Evidence | Fix |
|---|---|---|---|
| 1 | **99 % of the repository was tool output.** 1,416 of the ~1,430 tracked files were Quartus databases, reports, bitstreams and simulation work folders (79 MB checkout). | `git ls-files` | Removed; sources moved to `designs/` with history preserved |
| 2 | **The projects could not be rebuilt.** `.gitignore` ignored the Quartus project and constraint files (`*.qpf`, `*.qsf`, `*.sdc`) — the sources — while tracking everything Quartus generates. | `.gitignore` | Inverted: sources tracked, tool output ignored; projects recreated by [Tcl scripts](../scripts/quartus/project.tcl) |
| 3 | **No timing constraints anywhere.** 51 "SDC file not found" critical warnings and 18 "timing not met" failures — false failures against Quartus' default 1 GHz clock. | Quartus message databases | An `.sdc` per project: real 50 MHz board clock, virtual clocks for combinational paths, false paths for buttons and LEDs |
| 4 | **The UART testbench printed wrong values.** Its hand-written hex formatter reversed the nibbles: `'H'` (0x48) was printed as `0x84`. | Running the original testbench under GHDL | BFM uses VHDL-2008's standard `to_hstring` |
| 5 | **The "inferred latch" lab inferred no latch.** It assigned `'Z'` in the branch meant to be missing, so Quartus built a tri-state output (0 registers in the synthesis report). | Quartus synthesis summary | [Real latch demo + latch-free fix](../designs/02_sequential/inferred_latch/), and a CI gate that rejects latches |
| 6 | **`d_flip_flop_8bit` was 6 bits wide**, with 8-bit comments. The pin report shows why: six free switches/LEDs on the board. | `.pin` report | `WIDTH` generic: 8 by default, 6 in the board build |
| 7 | **Non-standard arithmetic packages.** Four files used Synopsys' `std_logic_arith`/`std_logic_unsigned` (GHDL needs `-fsynopsys` to accept them). | GHDL analysis | `ieee.numeric_std` throughout; CI requires all RTL to be strict VHDL-93 |
| 8 | **The traffic light had no timing.** It changed state on every clock: at 50 MHz, orange lasted 20 ns. | RTL review | Timed phases, synchronized and latched request ([details](../designs/03_systems/traffic_light/)) |
| 9 | **Testbenches did not check anything.** The adder and decoder testbenches only applied stimulus; correctness was judged by looking at waveforms. | Testbench review | Self-checking VUnit testbench with a reference model for every design |
| 10 | **Housekeeping.** A testbench saved twice (once under the design's name), sources inside Quartus' `output_files/`, an architecture without its entity, a pasted counter test table at the end of the latch file, chat-assistant comments (`-- ✅ FIXED`), empty description files, a Quartus crash dump with system information, and waveform files with absolute `C:/Users/...` paths. | Repository review | Removed or consolidated; every design folder has the same `rtl/ tb/ quartus/` layout and a README |

## Caught by the new checks during the rework

The point of verification infrastructure is that it also catches *your own* new
mistakes. It did:

| # | Finding | Caught by | Fix |
|---|---|---|---|
| 11 | The traffic-light FSM could **power up in the unused fourth encoding** of its 2-bit state register, with no car lamp lit. Every testbench starts with a reset, so simulation never saw it. | Formal proof (base case, cycle 0) | Explicit power-up values |
| 12 | The RAM's **read latency was never tested**: an asynchronous-read RAM passed every test. | Mutation testing (19/20 → 20/20) | `read_latency_is_one_clock` test |
| 13 | A register test contained a **check that could never fail**. | Code review, then confirmed by a mutant | Test rewritten; the rising-edge mutant now fails two tests |
| 14 | UART tests reported **5× too many bytes**: VUnit's `length(queue)` counts stored bytes (a type tag + 4 bytes per integer), not items. | Failing test, debug print | The monitors count items explicitly |
| 15 | CI could have **passed with a failing proof**: `check | tee summary` exits with `tee`'s status when GitHub's default shell has no `pipefail`. | Review of the workflow | `shell: bash` (runs with `-eo pipefail`), verified locally |
| 16 | Induction proofs failed from **unreachable states of the verification logic** (a stale counter, a reference frame with a 0 stop bit), and GHDL's PSL enable flip-flops let induction switch properties off. | Reading the counterexample traces | Stale-free helper logic, model invariants, `opt_dff` in the flow ([details](../formal/README.md)) |
| 17 | A guessed response-time bound was **loose**. | Proof still passed with a tighter bound | Bound tightened to the proven worst case; one cycle less produces a counterexample |
| 18 | The systolic animation's time window **overlapped the next tile**. The RTL was right — the next tile legitimately starts after exactly K + R + C − 1 cycles. | The figure script asserts the RTL trace against the systolic schedule | Window fixed; the tile period is now confirmed from raw waveform data too |
| 19 | Figure drafts showed a **fabricated ramp and an extrapolated frame end** on the UART waveform. | Looking at the rendered image | Plot only recorded samples; the test now runs until the line is idle again and checks it |

## Lessons

1. **A test is only evidence if it can fail.** Mutation testing turns "the tests
   pass" into "the tests would have caught these 20 bugs".
2. **Every testbench resets first, so simulation never sees power-up.** Formal
   verification from the initial state does.
3. **Tool output is not source.** Commit what you wrote; regenerate what tools write.
4. **Prefer the standard library.** Both the hex-printing bug and the
   `std_logic_arith` issue came from re-implementing or importing something
   non-standard.
5. **Look at the plot.** Two figure defects were only visible in the rendered image.
