--------------------------------------------------------------------------------
-- d_register : WIDTH-bit register of D flip-flops
--
-- * negative-edge triggered (lab requirement: captures d on the falling edge)
-- * asynchronous, active-high reset: q clears immediately, without a clock
--
-- The lab board exposes 6 switches/LEDs for this exercise, so the Quartus
-- build sets WIDTH = 6; the default is a full byte.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity d_register is
  generic (
    WIDTH : positive := 8
  );
  port (
    clk  : in  std_logic;
    arst : in  std_logic;                              -- async reset, active high
    d    : in  std_logic_vector(WIDTH - 1 downto 0);
    q    : out std_logic_vector(WIDTH - 1 downto 0)
  );
end entity d_register;

architecture rtl of d_register is
begin
  process (clk, arst)
  begin
    if arst = '1' then
      q <= (others => '0');
    elsif falling_edge(clk) then
      q <= d;
    end if;
  end process;
end architecture rtl;
