# Inferred latches — the bug, the fix, and a gate that keeps it fixed

> Course week 4 · the classic accidental-latch mistake

| File | Contents |
|---|---|
| [`rtl/latch_inferred.vhd`](rtl/latch_inferred.vhd) | **Deliberately broken**: `output2` is not assigned on every path |
| [`rtl/latch_free.vhd`](rtl/latch_free.vhd) | The fix: default assignments at the top of the process |
| [`tb/tb_inferred_latch.vhd`](tb/tb_inferred_latch.vhd) | Shows the latch remembering its past |

## Why it matters

In a combinational process, an output that is not assigned on some path has to
*keep* its old value. Keeping a value is memory, so synthesis builds a
level-sensitive **latch**: un-clocked storage that static timing analysis cannot
handle properly and that can glitch. It is one of the first things an RTL review
looks for.

```vhdl
process (a, b)                       process (a, b)
begin                                begin
  if a = '0' then                      output1 <= '0';   -- defaults: every path
    output1 <= '0'; output2 <= '0';    output2 <= '0';   -- assigns every output
  elsif b = '1' then                   if a = '1' and b = '1' then
    output1 <= '1'; output2 <= '1';      output1 <= '1';
  else                                   output2 <= '1';
    output1 <= '0';                    end if;
    -- output2 not assigned: LATCH   end process;
  end if;
end process;
```

## What was wrong with the lab version

The lab file assigned `output2 <= 'Z'` in the "missing" branch, with the comment
*"shows latch behavior"*. Assigning `'Z'` **is** an assignment, so no latch was
inferred: Quartus built a tri-state output instead (0 registers, 2 LEs in the
original synthesis report). The file also ended with a pasted copy of the up/down
counter's test table. `latch_inferred.vhd` now really shows the textbook latch.

## Verification

| Test case | What it shows |
|---|---|
| `latch_inferred_remembers_its_past` | The same input (`a=1, b=0`) gives `output2 = '1'` after `(1,1)` and `'0'` after `(0,0)`: the output depends on history |
| `latch_free_has_no_memory` | Same sequence, same answer every time |
| `latch_free_matches_truth_table` | Exhaustive: both outputs equal `a and b` |

## The latch gate

`scripts/synth_check.py` synthesizes every design with GHDL, which **refuses to
infer a latch** unless `--latches` is given. In CI, every design must synthesize
without it — and `latch_inferred` must *fail* without it and pass with it, which
proves the gate itself works:

```
$ ghdl --synth --std=08 latch_inferred
latch_inferred.vhd:27:3:error: latch infered for net "output2" (use --latches)
```
