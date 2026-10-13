--------------------------------------------------------------------------------
-- seven_segment_decoder : 4-bit hex digit -> 7-segment pattern (0-9, A-F)
--
-- Segment layout         seg bit order (as in the table below):
--      a                   seg(6) = a   seg(3) = d   seg(0) = g
--    f   b                 seg(5) = b   seg(2) = e
--      g                   seg(4) = c   seg(1) = f
--    e   c
--      d
--
-- The lab board uses a common-anode display (a segment lights when its pin
-- is driven low), hence ACTIVE_LOW = true by default.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity seven_segment_decoder is
  generic (
    ACTIVE_LOW : boolean := true
  );
  port (
    hex : in  std_logic_vector(3 downto 0);
    seg : out std_logic_vector(6 downto 0)   -- "abcdefg"
  );
end entity seven_segment_decoder;

architecture behavioral of seven_segment_decoder is
  signal lit : std_logic_vector(6 downto 0);  -- '1' = segment on
begin

  process (hex)
  begin
    case hex is                      --  abcdefg
      when "0000" => lit <= "1111110";   -- 0
      when "0001" => lit <= "0110000";   -- 1
      when "0010" => lit <= "1101101";   -- 2
      when "0011" => lit <= "1111001";   -- 3
      when "0100" => lit <= "0110011";   -- 4
      when "0101" => lit <= "1011011";   -- 5
      when "0110" => lit <= "1011111";   -- 6
      when "0111" => lit <= "1110000";   -- 7
      when "1000" => lit <= "1111111";   -- 8
      when "1001" => lit <= "1111011";   -- 9
      when "1010" => lit <= "1110111";   -- A
      when "1011" => lit <= "0011111";   -- b
      when "1100" => lit <= "1001110";   -- C
      when "1101" => lit <= "0111101";   -- d
      when "1110" => lit <= "1001111";   -- E
      when "1111" => lit <= "1000111";   -- F
      when others => lit <= "0000000";   -- blank for non-binary input
    end case;
  end process;

  seg <= not lit when ACTIVE_LOW else lit;

end architecture behavioral;
