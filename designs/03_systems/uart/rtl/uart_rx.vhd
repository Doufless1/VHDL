--------------------------------------------------------------------------------
-- uart_rx : UART receiver, 8N1, samples every bit in its centre
--
--   * rx comes from another clock domain (the sender's crystal), so it passes
--     a 2-flop synchronizer before any logic looks at it (metastability)
--   * a falling edge starts a frame; the start bit is checked again half a
--     bit later, so glitches shorter than half a bit are ignored
--   * the 8 data bits and the stop bit are sampled one bit time apart,
--     i.e. in the middle of each bit
--   * stop bit = '0' -> frame_error pulse and the byte is dropped; the
--     receiver then waits for the line to go high again (break condition)
--
-- Centre sampling tolerates roughly +-4 % total baud mismatch between sender
-- and receiver (the last sample, 9.5 bits after the start edge, may drift by
-- less than half a bit).
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity uart_rx is
  generic (
    CLK_FREQ : positive := 50_000_000;   -- clock frequency in Hz
    BAUD     : positive := 9_600         -- bit rate in bit/s
  );
  port (
    clk         : in  std_logic;
    rst         : in  std_logic;                     -- synchronous, active high
    rx          : in  std_logic;                     -- asynchronous serial input
    rx_data     : out std_logic_vector(7 downto 0);  -- last good byte
    rx_valid    : out std_logic;                     -- 1-cycle pulse: new byte
    frame_error : out std_logic                      -- 1-cycle pulse: bad stop bit
  );
end entity uart_rx;

architecture rtl of uart_rx is
  constant CLKS_PER_BIT : positive := (CLK_FREQ + BAUD / 2) / BAUD;  -- rounded
  constant HALF_BIT     : positive := CLKS_PER_BIT / 2;

  type state_t is (IDLE, START, DATA, STOP, WAIT_IDLE);
  signal state    : state_t := IDLE;

  signal rx_sync  : std_logic;
  signal cnt      : natural range 0 to CLKS_PER_BIT - 1 := 0;
  signal bit_idx  : natural range 0 to 7 := 0;
  signal shreg    : std_logic_vector(7 downto 0) := (others => '0');
  signal data_reg : std_logic_vector(7 downto 0) := (others => '0');
  signal valid    : std_logic := '0';
  signal ferr     : std_logic := '0';
begin

  assert CLKS_PER_BIT >= 4
    report "uart_rx: need at least 4 clock cycles per bit" severity failure;

  u_sync : entity work.sync_2ff
    generic map (INIT => '1')                -- the line idles high
    port map (
      clk      => clk,
      async_in => rx,
      sync_out => rx_sync
    );

  process (clk)
  begin
    if rising_edge(clk) then
      valid <= '0';
      ferr  <= '0';

      if rst = '1' then
        state   <= IDLE;
        cnt     <= 0;
        bit_idx <= 0;
      else
        case state is
          when IDLE =>                       -- wait for the start edge
            cnt <= 0;
            if rx_sync = '0' then
              state <= START;
            end if;

          when START =>                      -- centre of the start bit?
            if cnt = HALF_BIT - 1 then
              cnt <= 0;
              if rx_sync = '0' then
                bit_idx <= 0;
                state   <= DATA;
              else
                state   <= IDLE;             -- too short: glitch
              end if;
            else
              cnt <= cnt + 1;
            end if;

          when DATA =>                       -- centre of d0 .. d7
            if cnt = CLKS_PER_BIT - 1 then
              cnt   <= 0;
              shreg <= rx_sync & shreg(7 downto 1);   -- LSB arrives first
              if bit_idx = 7 then
                state <= STOP;
              else
                bit_idx <= bit_idx + 1;
              end if;
            else
              cnt <= cnt + 1;
            end if;

          when STOP =>                       -- centre of the stop bit
            if cnt = CLKS_PER_BIT - 1 then
              cnt <= 0;
              if rx_sync = '1' then
                data_reg <= shreg;
                valid    <= '1';
                state    <= IDLE;
              else
                ferr  <= '1';
                state <= WAIT_IDLE;
              end if;
            else
              cnt <= cnt + 1;
            end if;

          when WAIT_IDLE =>                  -- line held low (break)
            if rx_sync = '1' then
              state <= IDLE;
            end if;
        end case;
      end if;
    end if;
  end process;

  rx_data     <= data_reg;
  rx_valid    <= valid;
  frame_error <= ferr;

end architecture rtl;
