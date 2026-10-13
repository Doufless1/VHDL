--------------------------------------------------------------------------------
-- parity_display_top : shows a 4-bit switch value, or its parity bit, on a
-- 7-segment display (hierarchy lab: two sub-blocks wired together)
--
--   show_parity = '0' : display a as a hex digit (0-F)
--   show_parity = '1' : display the even-parity bit of a (0 or 1)
--
--     a ---+----------------------+
--          |                    +-+-----+    +---------------+
--          +--> even_parity --->|  mux  |--->| seven_segment |---> seg_n
--                               +-------+    |   _decoder    |
--               show_parity --------+        +---------------+
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity parity_display_top is
  port (
    a           : in  std_logic_vector(3 downto 0);   -- switches
    show_parity : in  std_logic;                      -- display select
    seg_n       : out std_logic_vector(6 downto 0)    -- "abcdefg", active low
  );
end entity parity_display_top;

architecture structural of parity_display_top is
  signal parity  : std_logic;
  signal display : std_logic_vector(3 downto 0);
begin

  u_parity : entity work.even_parity
    generic map (WIDTH => 4)
    port map (
      data   => a,
      parity => parity
    );

  display <= a when show_parity = '0' else "000" & parity;

  u_decoder : entity work.seven_segment_decoder
    generic map (ACTIVE_LOW => true)
    port map (
      hex => display,
      seg => seg_n
    );

end architecture structural;
