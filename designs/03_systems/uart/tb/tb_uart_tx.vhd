--------------------------------------------------------------------------------
-- tb_uart_tx : self-checking test of the UART transmitter
--
-- A passive monitor (uart_receive from the BFM package) decodes every frame
-- on the tx line into a queue; the test cases drive the valid/ready port
-- and compare what came out of the line. Bit timing is measured to the
-- femtosecond against the design's CLKS_PER_BIT.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

library osvvm;
use osvvm.RandomPkg.all;

use work.uart_bfm_pkg.all;

entity tb_uart_tx is
  generic (
    runner_cfg : string;
    CLK_FREQ       : positive := 10_000_000;
    BAUD           : positive := 1_000_000;
    BYTES_PER_TEST : positive := 64
  );
end entity tb_uart_tx;

architecture tb of tb_uart_tx is
  constant CLK_PERIOD   : time     := 1 sec / CLK_FREQ;
  constant CLKS_PER_BIT : positive := (CLK_FREQ + BAUD / 2) / BAUD;
  constant BIT_TIME     : time     := CLKS_PER_BIT * CLK_PERIOD;
  constant FRAME_TIME   : time     := 10 * BIT_TIME;

  signal clk      : std_logic := '0';
  signal rst      : std_logic := '1';
  signal tx_data  : std_logic_vector(7 downto 0) := (others => '0');
  signal tx_valid : std_logic := '0';
  signal tx_ready : std_logic;
  signal tx       : std_logic;

  -- VUnit queues hold typed bytes, so length() is not an item count:
  -- the monitor counts decoded frames itself
  constant received   : queue_t := new_queue;
  signal   n_received : natural := 0;
begin

  clk <= not clk after CLK_PERIOD / 2;

  u_dut : entity work.uart_tx
    generic map (CLK_FREQ => CLK_FREQ, BAUD => BAUD)
    port map (clk => clk, rst => rst, tx_data => tx_data, tx_valid => tx_valid,
              tx_ready => tx_ready, tx => tx);

  monitor : process
    variable data    : std_logic_vector(7 downto 0);
    variable stop_ok : boolean;
  begin
    uart_receive(tx, BIT_TIME, data, stop_ok);
    check_true(stop_ok, "stop bit of " & printable(data));
    push(received, to_integer(unsigned(data)));
    n_received <= n_received + 1;
  end process monitor;

  main : process
    variable rnd      : RandomPType;
    variable expected : integer_vector(0 to BYTES_PER_TEST - 1);
    variable t_edge   : time;
    variable t_start  : time;

    procedure send (value : natural) is            -- one handshake transfer
    begin
      tx_data  <= std_logic_vector(to_unsigned(value, 8));
      tx_valid <= '1';
      wait until rising_edge(clk) and tx_ready = '1';
      tx_valid <= '0';
    end procedure;

    procedure wait_received (count : natural) is
    begin
      for i in 1 to 20 * count loop               -- generous timeout
        exit when n_received >= count;
        wait for FRAME_TIME / 2;
      end loop;
      check_equal(n_received, count, "number of frames received");
    end procedure;
  begin
    test_runner_setup(runner, runner_cfg);
    rnd.InitSeed(rnd'instance_name);
    info("CLK_FREQ=" & to_string(CLK_FREQ) & " BAUD=" & to_string(BAUD) &
         " -> " & to_string(CLKS_PER_BIT) & " clocks per bit");

    while test_suite loop
      rst <= '1';
      wait for 5 * CLK_PERIOD;
      wait until rising_edge(clk);
      rst <= '0';

      if run("baud_rate_error_below_one_percent") then
        -- the closest bit time the clock can make must be within 1 % of 1/BAUD
        check(abs(real(CLKS_PER_BIT) * real(BAUD) / real(CLK_FREQ) - 1.0) < 0.01,
              "baud error too large for CLK_FREQ / BAUD");

      elsif run("idle_line_is_high_and_ready") then
        for i in 1 to 3 * CLKS_PER_BIT loop
          wait until rising_edge(clk);
          check_equal(tx, '1', "idle line");
          check_equal(tx_ready, '1', "ready while idle");
        end loop;

      elsif run("frame_timing_is_exact") then
        -- 0x55 toggles the line on every bit: 10 edges, each one bit apart
        send(16#55#);
        wait until tx = '0';
        t_edge := now;
        for i in 1 to 9 loop
          wait on tx;
          check_equal(now - t_edge, BIT_TIME, "bit " & to_string(i) & " duration");
          t_edge := now;
        end loop;
        wait_received(1);
        check_equal(pop_integer(received), 16#55#, "byte value");

      elsif run("single_byte") then
        send(character'pos('H'));
        wait_received(1);
        check_equal(pop_integer(received), character'pos('H'), "'H'");
        wait until tx_ready = '1' for BIT_TIME;     -- after the stop bit ...
        wait for BIT_TIME;
        check_equal(tx_ready, '1', "ready again after the frame");
        check_equal(tx, '1', "line back to idle");

      elsif run("back_to_back_stream_has_no_gaps") then
        for i in expected'range loop
          expected(i) := rnd.RandInt(0, 255);
        end loop;
        t_start := now;
        tx_valid <= '1';
        for i in expected'range loop              -- keep valid high: streaming
          tx_data <= std_logic_vector(to_unsigned(expected(i), 8));
          wait until rising_edge(clk) and tx_ready = '1';
        end loop;
        tx_valid <= '0';
        wait_received(expected'length);
        for i in expected'range loop
          check_equal(pop_integer(received), expected(i), "stream byte " & to_string(i));
        end loop;
        -- each frame may add at most one clock of idle (stop bit extension)
        check(now - t_start <= expected'length * (FRAME_TIME + CLK_PERIOD) + FRAME_TIME,
              "stream took " & to_string(now - t_start));

      elsif run("data_is_captured_at_handshake") then
        send(16#A5#);
        wait until rising_edge(clk);
        check_equal(tx_ready, '0', "busy while sending");
        tx_data <= x"FF";                         -- changing data mid-frame ...
        wait_received(1);
        check_equal(pop_integer(received), 16#A5#, "... must not corrupt the frame");
      end if;
    end loop;

    test_runner_cleanup(runner);
  end process main;

end architecture tb;
