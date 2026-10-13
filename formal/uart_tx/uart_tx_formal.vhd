--------------------------------------------------------------------------------
-- uart_tx_formal : end-to-end formal proof of the UART transmitter
--
-- A tiny reference model records every byte accepted on the valid/ready port
-- and the time since acceptance. The properties then say that the serial line
-- carries exactly that frame - start bit, the 8 data bits LSB first, stop bit
-- - each bit for exactly CLKS_PER_BIT cycles, that ready is low for precisely
-- the duration of the frame, and that the idle line is high.
--
-- The model checker proves this for every possible byte, every handshake
-- timing and every reset pattern (CLKS_PER_BIT = 2 keeps the state space
-- small; the RTL is the same for any divider). Run: make formal
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity uart_tx_formal is
  port (
    clk      : in std_logic;
    rst      : in std_logic;
    tx_data  : in std_logic_vector(7 downto 0);
    tx_valid : in std_logic
  );
end entity uart_tx_formal;

architecture formal of uart_tx_formal is
  constant CLKS_PER_BIT : positive := 2;
  constant FRAME_CYCLES : positive := 10 * CLKS_PER_BIT;

  signal tx_ready, tx : std_logic;

  -- reference model: the frame being sent and the cycles since it was accepted
  signal sending : std_logic := '0';
  signal frame   : std_logic_vector(9 downto 0) := (others => '1');  -- stop & data & start
  signal t       : natural range 0 to FRAME_CYCLES - 1 := 0;

  signal line_ok, ready_ok, idle_ok, model_ok : boolean;
begin

  u_dut : entity work.uart_tx
    generic map (CLK_FREQ => CLKS_PER_BIT, BAUD => 1)
    port map (clk => clk, rst => rst, tx_data => tx_data, tx_valid => tx_valid,
              tx_ready => tx_ready, tx => tx);

  reference : process (clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        sending <= '0';
        t       <= 0;
      elsif sending = '0' then
        if tx_valid = '1' and tx_ready = '1' then
          sending <= '1';
          t       <= 0;
          frame   <= '1' & tx_data & '0';
        end if;
      elsif t = FRAME_CYCLES - 1 then
        sending <= '0';
        t       <= 0;
      else
        t <= t + 1;
      end if;
    end if;
  end process reference;

  -- bit k of the frame is on the line during cycles k*CLKS_PER_BIT ..
  -- (k+1)*CLKS_PER_BIT - 1 after acceptance
  line_ok  <= sending = '0' or (t < FRAME_CYCLES and tx = frame(t / CLKS_PER_BIT));
  -- the transmitter is busy for exactly one frame per accepted byte
  ready_ok <= tx_ready = not sending;
  -- an idle line is high (otherwise a receiver would see a start bit)
  idle_ok  <= sending = '1' or tx = '1';
  -- invariants of the reference model itself. Trivially true, but stating
  -- them strengthens the induction step: otherwise induction may start from
  -- a model state holding a frame with a '0' stop bit, which it never loads.
  model_ok <= frame(9) = '1' and (sending = '0' or frame(0) = '0') and t < FRAME_CYCLES;

  default clock is rising_edge(clk);

  line_carries_the_frame  : assert always line_ok;
  ready_exactly_when_idle : assert always ready_ok;
  idle_line_is_high       : assert always idle_ok;
  model_invariants        : assert always model_ok;

end architecture formal;
