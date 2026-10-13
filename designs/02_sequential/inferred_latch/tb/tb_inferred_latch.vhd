--------------------------------------------------------------------------------
-- tb_inferred_latch : demonstrates why latch_inferred is a bug
--
-- A combinational block's outputs depend only on its current inputs. For
-- latch_inferred the input a=1, b=0 gives a different output2 depending on
-- what happened before - the circuit has memory. latch_free gives the same
-- answer every time and matches its truth table exhaustively.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_inferred_latch is
  generic (
    runner_cfg : string
  );
end entity tb_inferred_latch;

architecture tb of tb_inferred_latch is
  signal a, b                 : std_logic := '0';
  signal latch_o1, latch_o2   : std_logic;
  signal free_o1, free_o2     : std_logic;
begin

  u_latch : entity work.latch_inferred
    port map (a => a, b => b, output1 => latch_o1, output2 => latch_o2);

  u_free : entity work.latch_free
    port map (a => a, b => b, output1 => free_o1, output2 => free_o2);

  main : process
    procedure apply (va, vb : std_logic) is
    begin
      a <= va;
      b <= vb;
      wait for 10 ns;
    end procedure;
  begin
    test_runner_setup(runner, runner_cfg);

    while test_suite loop

      if run("latch_free_matches_truth_table") then
        for va in std_logic range '0' to '1' loop
          for vb in std_logic range '0' to '1' loop
            apply(va, vb);
            check_equal(free_o1, va and vb, "output1");
            check_equal(free_o2, va and vb, "output2");
          end loop;
        end loop;

      elsif run("latch_inferred_remembers_its_past") then
        apply('1', '1');                       -- output2 <= '1'
        apply('1', '0');                       -- output2 not assigned: holds
        check_equal(latch_o2, '1', "after (1,1) -> (1,0)");
        apply('0', '0');                       -- output2 <= '0'
        apply('1', '0');                       -- same input as before ...
        check_equal(latch_o2, '0', "after (0,0) -> (1,0)");
        info("same input a=1 b=0 gave output2 = '1' and then '0': this is memory, not logic");

      elsif run("latch_free_has_no_memory") then
        apply('1', '1');
        apply('1', '0');
        check_equal(free_o2, '0', "after (1,1) -> (1,0)");
        apply('0', '0');
        apply('1', '0');
        check_equal(free_o2, '0', "after (0,0) -> (1,0)");
      end if;

    end loop;

    test_runner_cleanup(runner);
  end process main;

end architecture tb;
