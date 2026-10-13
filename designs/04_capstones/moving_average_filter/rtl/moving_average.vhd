--------------------------------------------------------------------------------
-- moving_average : streaming moving-average (boxcar) filter, one sample/clock
--
-- The second final assignment of the course, built as reusable DSP IP:
--
--   y[n] = ( x[n] + x[n-1] + ... + x[n-N+1] ) / N        N = 2**LOG2_TAPS
--
-- Two tricks keep the hardware independent of N:
--
--   1. Recursive running sum (the integrator-comb idea behind CIC filters):
--        acc[n] = acc[n-1] + x[n] - x[n-N]
--      one adder and one subtractor instead of an N-input adder tree.
--   2. N is a power of two, so the division is an arithmetic right shift -
--      free in hardware (just wiring). The shift rounds towards -infinity
--      (floor), exactly like Python's  >>  on integers.
--
-- Bit growth: a sum of N signed DATA_WIDTH-bit samples needs
-- DATA_WIDTH + LOG2_TAPS bits, so acc can never overflow. Intermediate
-- wrap-around inside acc + x[n] - x[n-N] is harmless: two's-complement
-- arithmetic is exact modulo 2**ACC_WIDTH and the final sum is in range.
--
-- Interface: AXI4-Stream style valid without backpressure (the filter accepts
-- a sample every cycle). Latency: 1 clock. The delay line starts zeroed, so
-- the first N-1 outputs average over the samples received so far plus zeros.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity moving_average is
  generic (
    DATA_WIDTH : positive := 12;    -- signed sample width (e.g. a 12-bit ADC)
    LOG2_TAPS  : natural  := 3      -- window length N = 2**LOG2_TAPS
  );
  port (
    clk     : in  std_logic;
    rst     : in  std_logic;                                  -- synchronous
    s_valid : in  std_logic;                                  -- input sample
    s_data  : in  std_logic_vector(DATA_WIDTH - 1 downto 0);  -- signed
    m_valid : out std_logic;                                  -- output sample
    m_data  : out std_logic_vector(DATA_WIDTH - 1 downto 0)   -- signed
  );
end entity moving_average;

architecture rtl of moving_average is
  constant TAPS      : positive := 2**LOG2_TAPS;
  constant ACC_WIDTH : positive := DATA_WIDTH + LOG2_TAPS;

  -- delay line: delay(0) = newest sample, delay(TAPS-1) = oldest
  type delay_t is array (0 to TAPS - 1) of signed(DATA_WIDTH - 1 downto 0);
  signal delay : delay_t := (others => (others => '0'));

  signal acc   : signed(ACC_WIDTH - 1 downto 0) := (others => '0');
  signal valid : std_logic := '0';
begin

  process (clk)
    variable x_new, x_old : signed(DATA_WIDTH - 1 downto 0);
  begin
    if rising_edge(clk) then
      if rst = '1' then
        delay <= (others => (others => '0'));
        acc   <= (others => '0');
        valid <= '0';
      else
        valid <= s_valid;
        if s_valid = '1' then
          x_new := signed(s_data);
          x_old := delay(TAPS - 1);                    -- sample leaving the window
          for i in TAPS - 1 downto 1 loop
            delay(i) <= delay(i - 1);
          end loop;
          delay(0) <= x_new;
          acc <= acc + resize(x_new, ACC_WIDTH) - resize(x_old, ACC_WIDTH);
        end if;
      end if;
    end if;
  end process;

  m_valid <= valid;
  m_data  <= std_logic_vector(acc(ACC_WIDTH - 1 downto LOG2_TAPS));   -- acc / N

end architecture rtl;
