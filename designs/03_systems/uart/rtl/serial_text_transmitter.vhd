--------------------------------------------------------------------------------
-- serial_text_transmitter : sends a text message over UART, over and over
--
-- Course final assignment ("serial send at 9600 baud"). The lab version mixed
-- the bit timing and the text ROM in one state machine; it is now split into
-- a character ROM that feeds the reusable uart_tx through its handshake.
--
--   reset (button) -> sync_2ff -> rst
--   ROM("HELLO!\r\n") --tx_data/tx_valid--> uart_tx --> tx pin
--                     <------tx_ready------
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity serial_text_transmitter is
  generic (
    CLK_FREQ : positive := 50_000_000;
    BAUD     : positive := 9_600;
    MESSAGE  : string   := "HELLO!" & CR & LF
  );
  port (
    clk   : in  std_logic;
    reset : in  std_logic;   -- push button, active high, asynchronous
    tx    : out std_logic    -- UART output (to a USB-serial adapter)
  );
end entity serial_text_transmitter;

architecture rtl of serial_text_transmitter is

  type rom_t is array (0 to MESSAGE'length - 1) of std_logic_vector(7 downto 0);

  function to_rom (s : string) return rom_t is
    variable rom : rom_t;
  begin
    for i in rom'range loop
      rom(i) := std_logic_vector(to_unsigned(character'pos(s(s'low + i)), 8));
    end loop;
    return rom;
  end function to_rom;

  constant ROM : rom_t := to_rom(MESSAGE);

  signal rst      : std_logic;
  signal index    : natural range 0 to ROM'high := 0;
  signal tx_byte  : std_logic_vector(7 downto 0);
  signal tx_valid : std_logic;
  signal tx_ready : std_logic;

begin

  -- the button is asynchronous: synchronise it before it resets anything;
  -- INIT = '1' also holds the design in reset for two cycles at power-up
  u_rst_sync : entity work.sync_2ff
    generic map (INIT => '1')
    port map (
      clk      => clk,
      async_in => reset,
      sync_out => rst
    );

  -- message pointer: advances on every accepted byte, wraps at the end
  process (clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        index <= 0;
      elsif tx_valid = '1' and tx_ready = '1' then
        if index = ROM'high then
          index <= 0;
        else
          index <= index + 1;
        end if;
      end if;
    end if;
  end process;

  tx_byte  <= ROM(index);
  tx_valid <= not rst;

  u_uart_tx : entity work.uart_tx
    generic map (
      CLK_FREQ => CLK_FREQ,
      BAUD     => BAUD
    )
    port map (
      clk      => clk,
      rst      => rst,
      tx_data  => tx_byte,
      tx_valid => tx_valid,
      tx_ready => tx_ready,
      tx       => tx
    );

end architecture rtl;
