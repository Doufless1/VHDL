--------------------------------------------------------------------------------
-- demux_1to4 : 1-to-4 demultiplexer, dataflow description (when/else)
--
-- Routes d to the output selected by s; the other outputs are '0'.
-- demux_1to4 is the inverse of mux_4to1: mux(demux(d, s), s) = d.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity demux_1to4 is
  port (
    d              : in  std_logic;                     -- data input
    s              : in  std_logic_vector(1 downto 0);  -- select
    y0, y1, y2, y3 : out std_logic
  );
end entity demux_1to4;

architecture dataflow of demux_1to4 is
begin
  y0 <= d when s = "00" else '0';
  y1 <= d when s = "01" else '0';
  y2 <= d when s = "10" else '0';
  y3 <= d when s = "11" else '0';
end architecture dataflow;
