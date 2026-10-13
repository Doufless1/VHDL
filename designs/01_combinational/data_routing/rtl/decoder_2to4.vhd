--------------------------------------------------------------------------------
-- decoder_2to4 : binary-to-one-hot decoder (2 inputs, 4 outputs)
--
--   a = "00" -> y = "0001"      a = "10" -> y = "0100"
--   a = "01" -> y = "0010"      a = "11" -> y = "1000"
--
-- Typical use: chip-select / address decoding (exactly one output is active).
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity decoder_2to4 is
  port (
    a : in  std_logic_vector(1 downto 0);
    y : out std_logic_vector(3 downto 0)   -- one-hot, y(i) = '1' when a = i
  );
end entity decoder_2to4;

architecture behavioral of decoder_2to4 is
begin
  process (a)
  begin
    case a is
      when "00"   => y <= "0001";
      when "01"   => y <= "0010";
      when "10"   => y <= "0100";
      when "11"   => y <= "1000";
      when others => y <= "0000";
    end case;
  end process;
end architecture behavioral;
