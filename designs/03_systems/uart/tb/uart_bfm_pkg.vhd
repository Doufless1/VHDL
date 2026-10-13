--------------------------------------------------------------------------------
-- uart_bfm_pkg : UART bus-functional models shared by the UART testbenches
--
-- uart_send    drives one 8N1 frame onto a line. The bit time is a parameter,
--              so a test can play an off-frequency sender, and the stop bit
--              can be forced to '0' to provoke a framing error.
-- uart_receive behaves like an ideal receiver: waits for the start edge,
--              samples every bit in its centre, reports the byte and whether
--              the stop bit was '1'.
-- printable    formats a byte for log messages: 'H' (0x48), <0D> (0x0D).
--
-- The original lab testbench printed bytes with a hand-written hex function
-- that emitted the nibbles in reverse order ('H' = 0x48 came out as "84").
-- The BFM now uses VHDL-2008's standard to_hstring.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package uart_bfm_pkg is

  procedure uart_send (
    signal   line     : out std_logic;
    constant data     : in  std_logic_vector(7 downto 0);
    constant bit_time : in  time;
    constant stop_bit : in  std_logic := '1');

  procedure uart_receive (
    signal   line     : in  std_logic;
    constant bit_time : in  time;
    variable data     : out std_logic_vector(7 downto 0);
    variable stop_ok  : out boolean);

  function printable (data : std_logic_vector(7 downto 0)) return string;

end package uart_bfm_pkg;

package body uart_bfm_pkg is

  procedure uart_send (
    signal   line     : out std_logic;
    constant data     : in  std_logic_vector(7 downto 0);
    constant bit_time : in  time;
    constant stop_bit : in  std_logic := '1') is
  begin
    line <= '0';                                   -- start bit
    wait for bit_time;
    for i in 0 to 7 loop                           -- data, LSB first
      line <= data(i);
      wait for bit_time;
    end loop;
    line <= stop_bit;                              -- stop bit
    wait for bit_time;
    line <= '1';                                   -- idle
  end procedure uart_send;

  procedure uart_receive (
    signal   line     : in  std_logic;
    constant bit_time : in  time;
    variable data     : out std_logic_vector(7 downto 0);
    variable stop_ok  : out boolean) is
  begin
    wait until line = '0';                         -- start edge
    wait for bit_time / 2;                         -- centre of the start bit
    for i in 0 to 7 loop
      wait for bit_time;                           -- centre of data bit i
      data(i) := line;
    end loop;
    wait for bit_time;                             -- centre of the stop bit
    stop_ok := line = '1';
  end procedure uart_receive;

  function printable (data : std_logic_vector(7 downto 0)) return string is
    constant code : natural := to_integer(unsigned(data));
  begin
    if code >= 32 and code < 127 then
      return "'" & character'val(code) & "' (0x" & to_hstring(data) & ")";
    else
      return "<" & to_hstring(data) & ">";
    end if;
  end function printable;

end package body uart_bfm_pkg;
