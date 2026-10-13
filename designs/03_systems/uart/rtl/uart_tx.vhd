--------------------------------------------------------------------------------
-- uart_tx : UART transmitter, 8 data bits, no parity, 1 stop bit (8N1)
--
-- Frame on the line (idle high):  start(0)  d0 d1 ... d7  stop(1)  - LSB first
--
-- Byte input is a valid/ready handshake (AXI4-Stream style): a byte is taken
-- on a rising edge where tx_valid = '1' and tx_ready = '1'. Holding tx_valid
-- high streams bytes back to back.
--
-- The bit counter restarts with every frame, so each bit lasts exactly
-- CLKS_PER_BIT cycles. Baud error = CLK_FREQ / (CLKS_PER_BIT * BAUD) - 1,
-- e.g. 50 MHz / 9600 baud -> 5208 cycles per bit -> +0.006 %.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity uart_tx is
  generic (
    CLK_FREQ : positive := 50_000_000;   -- clock frequency in Hz
    BAUD     : positive := 9_600         -- bit rate in bit/s
  );
  port (
    clk      : in  std_logic;
    rst      : in  std_logic;                      -- synchronous, active high
    tx_data  : in  std_logic_vector(7 downto 0);
    tx_valid : in  std_logic;
    tx_ready : out std_logic;                      -- '1' = idle, byte accepted
    tx       : out std_logic                       -- serial output
  );
end entity uart_tx;

architecture rtl of uart_tx is
  constant CLKS_PER_BIT : positive := (CLK_FREQ + BAUD / 2) / BAUD;  -- rounded

  signal busy      : std_logic := '0';
  signal tx_reg    : std_logic := '1';
  signal shreg     : std_logic_vector(8 downto 0) := (others => '1');  -- stop & data
  signal bits_left : natural range 0 to 9 := 0;    -- bits after the current one
  signal baud_cnt  : natural range 0 to CLKS_PER_BIT - 1 := 0;
begin

  process (clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        busy      <= '0';
        tx_reg    <= '1';
        shreg     <= (others => '1');
        bits_left <= 0;
        baud_cnt  <= 0;

      elsif busy = '0' then
        if tx_valid = '1' then                 -- accept byte, start bit now
          busy      <= '1';
          tx_reg    <= '0';
          shreg     <= '1' & tx_data;
          bits_left <= 9;
          baud_cnt  <= 0;
        end if;

      elsif baud_cnt /= CLKS_PER_BIT - 1 then  -- inside a bit
        baud_cnt <= baud_cnt + 1;

      else                                     -- end of a bit
        baud_cnt <= 0;
        if bits_left = 0 then                  -- stop bit sent: frame done
          busy <= '0';
        else                                   -- next data bit, then stop
          tx_reg    <= shreg(0);
          shreg     <= '1' & shreg(8 downto 1);
          bits_left <= bits_left - 1;
        end if;
      end if;
    end if;
  end process;

  tx_ready <= not busy;
  tx       <= tx_reg;

end architecture rtl;
