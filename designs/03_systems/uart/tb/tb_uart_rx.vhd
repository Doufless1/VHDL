--------------------------------------------------------------------------------
-- tb_uart_rx : self-checking test of the UART receiver
--
-- The receiver input is driven either by the BFM sender (ideal timing,
-- deliberate baud errors, glitches, broken stop bits, break) or by the real
-- uart_tx (loopback). A monitor collects everything uart_rx reports.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

library osvvm;
use osvvm.RandomPkg.all;

use work.uart_bfm_pkg.all;

entity tb_uart_rx is
  generic (
    runner_cfg     : string;
    CLK_FREQ       : positive := 10_000_000;
    BAUD           : positive := 1_000_000;
    BYTES_PER_TEST : positive := 256
  );
end entity tb_uart_rx;

architecture tb of tb_uart_rx is
  constant CLK_PERIOD : time := 1 sec / CLK_FREQ;
  constant BIT_TIME   : time := 1 sec / BAUD;          -- ideal sender

  signal clk         : std_logic := '0';
  signal rst         : std_logic := '1';
  signal bfm_line    : std_logic := '1';
  signal loopback    : boolean   := false;
  signal rx          : std_logic;
  signal rx_data     : std_logic_vector(7 downto 0);
  signal rx_valid    : std_logic;
  signal frame_error : std_logic;
  -- loopback transmitter
  signal tx_data     : std_logic_vector(7 downto 0) := (others => '0');
  signal tx_valid    : std_logic := '0';
  signal tx_ready    : std_logic;
  signal tx_line     : std_logic;

  -- VUnit queues hold typed bytes, so length() is not an item count:
  -- the monitor counts delivered bytes itself
  constant received   : queue_t := new_queue;
  signal   n_received : natural := 0;
  signal   n_errors   : natural := 0;
begin

  clk <= not clk after CLK_PERIOD / 2;
  rx  <= tx_line when loopback else bfm_line;

  u_dut : entity work.uart_rx
    generic map (CLK_FREQ => CLK_FREQ, BAUD => BAUD)
    port map (clk => clk, rst => rst, rx => rx, rx_data => rx_data,
              rx_valid => rx_valid, frame_error => frame_error);

  u_tx : entity work.uart_tx
    generic map (CLK_FREQ => CLK_FREQ, BAUD => BAUD)
    port map (clk => clk, rst => rst, tx_data => tx_data, tx_valid => tx_valid,
              tx_ready => tx_ready, tx => tx_line);

  monitor : process
  begin
    wait until rising_edge(clk);
    if rx_valid = '1' then
      push(received, to_integer(unsigned(rx_data)));
      n_received <= n_received + 1;
    end if;
    if frame_error = '1' then
      n_errors <= n_errors + 1;
    end if;
    check_false(rx_valid = '1' and frame_error = '1', "valid and error together");
  end process monitor;

  main : process
    variable rnd      : RandomPType;
    variable expected : integer_vector(0 to BYTES_PER_TEST - 1);

    procedure expect_bytes (values : integer_vector) is
    begin
      wait for 2 * BIT_TIME;                       -- last frame fully processed
      check_equal(n_received, values'length, "bytes received");
      for i in values'range loop
        exit when is_empty(received);
        check_equal(pop_integer(received), values(i), "byte " & to_string(i));
      end loop;
    end procedure;

    procedure send_random (bit_time : time) is
    begin
      for i in expected'range loop
        expected(i) := rnd.RandInt(0, 255);
        uart_send(bfm_line, std_logic_vector(to_unsigned(expected(i), 8)), bit_time);
      end loop;
      expect_bytes(expected);
      check_equal(n_errors, 0, "no framing errors");
    end procedure;
  begin
    test_runner_setup(runner, runner_cfg);
    rnd.InitSeed(rnd'instance_name);

    while test_suite loop
      rst <= '1';
      wait for 5 * CLK_PERIOD;
      rst <= '0';
      wait for BIT_TIME;

      if run("receives_every_byte_value") then
        for i in expected'range loop
          expected(i) := i mod 256;
          uart_send(bfm_line, std_logic_vector(to_unsigned(expected(i), 8)), BIT_TIME);
        end loop;
        expect_bytes(expected);
        check_equal(n_errors, 0, "no framing errors");

      elsif run("tolerates_sender_3_percent_slow") then
        send_random(BIT_TIME * 1.03);

      elsif run("tolerates_sender_3_percent_fast") then
        send_random(BIT_TIME * 0.97);

      elsif run("flags_framing_error_and_recovers") then
        uart_send(bfm_line, x"3C", BIT_TIME, stop_bit => '0');
        wait for 2 * BIT_TIME;
        check_equal(n_errors, 1, "framing error reported");
        check_true(is_empty(received), "a broken frame must not be delivered");
        uart_send(bfm_line, x"C3", BIT_TIME);
        expect_bytes((0 => 16#C3#));

      elsif run("ignores_start_bit_glitch") then
        bfm_line <= '0';                           -- 0.25 bit: noise, not a start bit
        wait for BIT_TIME / 4;
        bfm_line <= '1';
        wait for 3 * BIT_TIME;
        check_true(is_empty(received), "glitch must not produce a byte");
        check_equal(n_errors, 0, "glitch must not produce an error");
        uart_send(bfm_line, x"81", BIT_TIME);
        expect_bytes((0 => 16#81#));

      elsif run("recovers_from_break_condition") then
        bfm_line <= '0';                           -- line held low for 3 frames
        wait for 30 * BIT_TIME;
        bfm_line <= '1';
        wait for 2 * BIT_TIME;
        check_equal(n_errors, 1, "a break is one framing error, not a stream of bytes");
        check_true(is_empty(received), "no bytes from a break");
        uart_send(bfm_line, x"42", BIT_TIME);
        expect_bytes((0 => 16#42#));

      elsif run("loopback_with_uart_tx") then
        loopback <= true;
        wait for BIT_TIME;
        for i in expected'range loop
          expected(i) := rnd.RandInt(0, 255);
          tx_data     <= std_logic_vector(to_unsigned(expected(i), 8));
          tx_valid    <= '1';
          wait until rising_edge(clk) and tx_ready = '1';
        end loop;
        tx_valid <= '0';
        wait until rising_edge(clk) and tx_ready = '1';   -- last frame on the line
        expect_bytes(expected);
        check_equal(n_errors, 0, "no framing errors");
      end if;
    end loop;

    test_runner_cleanup(runner);
  end process main;

end architecture tb;
