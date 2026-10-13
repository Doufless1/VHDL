--------------------------------------------------------------------------------
-- latch_inferred : DELIBERATELY BROKEN - the classic accidental latch
--
-- Combinational process in which `output2` is not assigned on every path:
-- for a = '1' and b = '0' it keeps its previous value. Keeping a value is
-- memory, so synthesis has to build a level-sensitive latch - an
-- un-clocked storage element that breaks static timing analysis and can
-- glitch. See latch_free.vhd for the corrected version.
--
-- This file exists to demonstrate the problem: the synthesis check in CI
-- builds it with `ghdl --synth --latches` and verifies that every other
-- design is latch-free (GHDL rejects inferred latches by default).
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity latch_inferred is
  port (
    a, b    : in  std_logic;
    output1 : out std_logic;
    output2 : out std_logic
  );
end entity latch_inferred;

architecture behavioral of latch_inferred is
begin
  process (a, b)
  begin
    if a = '0' then
      output1 <= '0';
      output2 <= '0';
    elsif b = '1' then
      output1 <= '1';
      output2 <= '1';
    else
      output1 <= '0';
      -- output2 not assigned here -> it must hold its value -> latch
    end if;
  end process;
end architecture behavioral;
