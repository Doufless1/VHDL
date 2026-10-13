--------------------------------------------------------------------------------
-- tristate_buffer : WIDTH-bit tri-state driver for a shared bus
--
-- oe_n = '0' : the buffer drives `a` onto the bus
-- oe_n = '1' : the buffer releases the bus (high impedance, 'Z')
--
-- Several tristate_buffers may share one bus as long as at most one is
-- enabled at a time; two enabled drivers with different data is bus
-- contention (resolves to 'X' in simulation, short-circuit current in
-- hardware). Inside an FPGA, tri-states only exist in the I/O pins, so this
-- block belongs at the top level, driving an `inout` device pin.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity tristate_buffer is
  generic (
    WIDTH : positive := 8
  );
  port (
    a      : in    std_logic_vector(WIDTH - 1 downto 0);
    oe_n   : in    std_logic;                              -- output enable, active low
    bus_io : inout std_logic_vector(WIDTH - 1 downto 0)
  );
end entity tristate_buffer;

architecture behavioral of tristate_buffer is
begin
  bus_io <= a when oe_n = '0' else (others => 'Z');
end architecture behavioral;
