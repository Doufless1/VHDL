--------------------------------------------------------------------------------
-- up_down_counter : WIDTH-bit synchronous binary up/down counter
--
-- * counts on the rising edge while enable = '1'
-- * up_down = '1' counts up, '0' counts down; wraps modulo 2**WIDTH
-- * asynchronous, active-high reset to zero
--
-- Uses ieee.numeric_std (the IEEE standard arithmetic package) instead of the
-- vendor packages std_logic_arith / std_logic_unsigned from the course slides.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity up_down_counter is
  generic (
    WIDTH : positive := 8
  );
  port (
    clk     : in  std_logic;
    arst    : in  std_logic;                              -- async reset, active high
    enable  : in  std_logic;
    up_down : in  std_logic;                              -- '1' = up, '0' = down
    count   : out std_logic_vector(WIDTH - 1 downto 0)
  );
end entity up_down_counter;

architecture rtl of up_down_counter is
  signal count_reg : unsigned(WIDTH - 1 downto 0);
begin

  process (clk, arst)
  begin
    if arst = '1' then
      count_reg <= (others => '0');
    elsif rising_edge(clk) then
      if enable = '1' then
        if up_down = '1' then
          count_reg <= count_reg + 1;
        else
          count_reg <= count_reg - 1;
        end if;
      end if;
    end if;
  end process;

  count <= std_logic_vector(count_reg);

end architecture rtl;
