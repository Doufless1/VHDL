--------------------------------------------------------------------------------
-- tb_moving_average : scoreboard-based verification of the moving average
--
--   stimulus  --> DUT --> checker
--      |                    ^
--      +--> reference ------+   (bit-exact model: sum of the last N samples,
--           (expected queue)     floor-divided by N)
--
-- The stimulus process computes every expected output with the reference
-- model and pushes it into a queue; the checker pops one entry per DUT
-- output and compares. Directed tests cover the textbook responses
-- (impulse, step) and full-scale inputs that would overflow an accumulator
-- that is one bit too narrow. The noisy-sine test also writes a CSV that
-- scripts/make_figures.py turns into the plot in the README.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.textio.all;

library vunit_lib;
context vunit_lib.vunit_context;

library osvvm;
use osvvm.RandomPkg.all;

entity tb_moving_average is
  generic (
    runner_cfg : string;
    DATA_WIDTH : positive := 12;
    LOG2_TAPS  : natural  := 3
  );
end entity tb_moving_average;

architecture tb of tb_moving_average is
  constant CLK_PERIOD : time    := 10 ns;                -- 100 MHz
  constant TAPS       : natural := 2**LOG2_TAPS;
  constant X_MAX      : integer := 2**(DATA_WIDTH - 1) - 1;
  constant X_MIN      : integer := -2**(DATA_WIDTH - 1);

  signal clk     : std_logic := '0';
  signal rst     : std_logic := '1';
  signal s_valid : std_logic := '0';
  signal s_data  : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
  signal m_valid : std_logic;
  signal m_data  : std_logic_vector(DATA_WIDTH - 1 downto 0);

  constant scoreboard : queue_t := new_queue;   -- (input, expected) pairs
  signal n_sent       : natural := 0;
  signal n_checked    : natural := 0;
  signal write_csv    : boolean := false;
begin

  clk <= not clk after CLK_PERIOD / 2;

  u_dut : entity work.moving_average
    generic map (DATA_WIDTH => DATA_WIDTH, LOG2_TAPS => LOG2_TAPS)
    port map (clk => clk, rst => rst, s_valid => s_valid, s_data => s_data,
              m_valid => m_valid, m_data => m_data);

  ------------------------------------------------------------------------------
  checker : process
    file     csv          : text;
    variable row          : line;
    variable csv_open     : boolean := false;
    variable x, expected  : integer;
    variable got          : integer;
  begin
    wait until rising_edge(clk);
    if write_csv and not csv_open then
      file_open(csv, output_path(runner_cfg) & "samples.csv", write_mode);
      write(row, string'("n,input,output"));
      writeline(csv, row);
      csv_open := true;
    end if;

    if m_valid = '1' then
      check_false(is_empty(scoreboard), "output without a matching input");
      x        := pop_integer(scoreboard);
      expected := pop_integer(scoreboard);
      got      := to_integer(signed(m_data));
      check_equal(got, expected, "output " & to_string(n_checked) &
                                 " (input " & to_string(x) & ")");
      if csv_open then
        write(row, to_string(n_checked) & "," & to_string(x) & "," & to_string(got));
        writeline(csv, row);
      end if;
      n_checked <= n_checked + 1;
    end if;
  end process checker;

  ------------------------------------------------------------------------------
  stimulus : process
    type window_t is array (0 to TAPS - 1) of integer;
    variable window : window_t := (others => 0);    -- reference delay line
    variable rnd    : RandomPType;
    variable sent   : natural := 0;
    variable x      : integer;

    -- floor division, like an arithmetic shift right (VHDL "/" truncates)
    function floor_div (a : integer; n : positive) return integer is
    begin
      return (a - (a mod n)) / n;
    end function;

    -- send one sample (optionally after idle cycles) and score the result
    procedure send (value : integer; idle_cycles : natural := 0) is
      variable sum : integer := 0;
    begin
      for i in 1 to idle_cycles loop
        s_valid <= '0';
        wait until rising_edge(clk);
      end loop;
      window := value & window(0 to TAPS - 2);
      for i in window'range loop
        sum := sum + window(i);
      end loop;
      push(scoreboard, value);
      push(scoreboard, floor_div(sum, TAPS));
      s_valid <= '1';
      s_data  <= std_logic_vector(to_signed(value, DATA_WIDTH));
      wait until rising_edge(clk);
      s_valid <= '0';
      sent    := sent + 1;
      n_sent  <= sent;
    end procedure;

    procedure drain is
    begin
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      check_equal(n_checked, sent, "every input produced exactly one output");
      check_true(is_empty(scoreboard), "scoreboard empty");
    end procedure;

    function clamp (v : integer) return integer is
    begin
      if v > X_MAX then return X_MAX; elsif v < X_MIN then return X_MIN; end if;
      return v;
    end function;

    variable amplitude : integer;
  begin
    test_runner_setup(runner, runner_cfg);
    rnd.InitSeed(rnd'instance_name);
    info("N = " & to_string(TAPS) & " taps, " & to_string(DATA_WIDTH) & "-bit samples");

    rst <= '1';
    wait for 3 * CLK_PERIOD;
    wait until rising_edge(clk);
    rst <= '0';

    while test_suite loop

      if run("impulse_response_is_a_boxcar") then
        amplitude := TAPS * (X_MAX / TAPS);            -- divisible by N
        send(amplitude);
        for i in 1 to 2 * TAPS loop
          send(0);
        end loop;
        drain;                                         -- N outputs of A/N, then 0

      elsif run("step_response_ramps_in_n_samples") then
        for i in 1 to 3 * TAPS loop
          send(1000 mod (X_MAX + 1));
        end loop;
        drain;

      elsif run("full_scale_inputs_do_not_overflow") then
        for i in 1 to 2 * TAPS loop send(X_MAX); end loop;
        for i in 1 to 2 * TAPS loop send(X_MIN); end loop;
        for i in 1 to 2 * TAPS loop send(X_MAX); end loop;
        drain;

      elsif run("random_samples_with_gaps") then
        for i in 1 to 3000 loop
          send(rnd.RandInt(X_MIN, X_MAX), rnd.DistInt((7, 2, 1)));  -- 0..2 idle
        end loop;
        drain;

      elsif run("noisy_sine_wave") then
        write_csv <= true;
        wait until rising_edge(clk);
        for n in 0 to 399 loop
          x := integer(round(0.6 * real(X_MAX) * sin(MATH_2_PI * real(n) / 100.0)))
               + rnd.RandInt(-X_MAX / 5, X_MAX / 5);
          send(clamp(x));
        end loop;
        drain;
      end if;

    end loop;

    test_runner_cleanup(runner);
  end process stimulus;

end architecture tb;
