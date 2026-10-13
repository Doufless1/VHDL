--------------------------------------------------------------------------------
-- sync_2ff : multi-flop synchronizer for one asynchronous input bit
--
-- Brings a signal from outside the clock domain (push button, UART RX pin,
-- reset button) into `clk`. The first flop may go metastable; the extra
-- stage(s) give it a full clock period to resolve before anything uses it.
--
-- * Only for single-bit, level-type signals. Multi-bit buses must cross clock
--   domains through a handshake or an async FIFO, never through this block.
-- * No reset on purpose: a synchronizer must not depend on a signal that is
--   itself asynchronous. INIT sets the power-up / simulation value
--   (use '1' for an idle-high UART line or an active-high reset).
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity sync_2ff is
  generic (
    STAGES : positive  := 2;    -- number of flip-flops in the chain (>= 2)
    INIT   : std_logic := '0'   -- power-up value of every stage
  );
  port (
    clk      : in  std_logic;
    async_in : in  std_logic;   -- asynchronous input
    sync_out : out std_logic    -- synchronized to clk, STAGES cycles later
  );
end entity sync_2ff;

architecture rtl of sync_2ff is
  signal chain : std_logic_vector(STAGES - 1 downto 0) := (others => INIT);
begin

  assert STAGES >= 2
    report "sync_2ff: STAGES must be at least 2" severity failure;

  process (clk)
  begin
    if rising_edge(clk) then
      chain <= chain(STAGES - 2 downto 0) & async_in;
    end if;
  end process;

  sync_out <= chain(STAGES - 1);

end architecture rtl;
