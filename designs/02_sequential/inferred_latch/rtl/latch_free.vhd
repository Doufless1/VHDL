--------------------------------------------------------------------------------
-- latch_free : the corrected version of latch_inferred
--
-- Rule for combinational processes: every output gets a value on every path.
-- The simplest way to guarantee that is a default assignment at the top of
-- the process; later assignments override it. The result is a pure gate
-- network (here output1 = output2 = a and b).
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity latch_free is
  port (
    a, b    : in  std_logic;
    output1 : out std_logic;
    output2 : out std_logic
  );
end entity latch_free;

architecture behavioral of latch_free is
begin
  process (a, b)
  begin
    -- defaults: no path can leave an output unassigned
    output1 <= '0';
    output2 <= '0';

    if a = '1' and b = '1' then
      output1 <= '1';
      output2 <= '1';
    end if;
  end process;
end architecture behavioral;
