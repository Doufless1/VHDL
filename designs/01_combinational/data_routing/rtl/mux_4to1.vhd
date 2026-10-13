--------------------------------------------------------------------------------
-- mux_4to1 : 4-to-1 multiplexer, behavioural description with a case statement
--
--   y = d0 | d1 | d2 | d3 selected by s = "00" | "01" | "10" | "11"
--
-- The `when others` branch covers the non-binary std_logic values
-- ('U', 'X', 'Z', ...) that exist in simulation but never in hardware.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity mux_4to1 is
  port (
    d0, d1, d2, d3 : in  std_logic;                     -- data inputs
    s              : in  std_logic_vector(1 downto 0);  -- select
    y              : out std_logic
  );
end entity mux_4to1;

architecture behavioral of mux_4to1 is
begin
  process (s, d0, d1, d2, d3)
  begin
    case s is
      when "00"   => y <= d0;
      when "01"   => y <= d1;
      when "10"   => y <= d2;
      when "11"   => y <= d3;
      when others => y <= '0';
    end case;
  end process;
end architecture behavioral;
