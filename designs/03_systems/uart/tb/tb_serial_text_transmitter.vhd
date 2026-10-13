--------------------------------------------------------------------------------
-- tb_serial_text_transmitter : top-level test of the course final assignment
--
-- Runs the design at its real settings (50 MHz clock, 9600 baud) and decodes
-- the serial line with the BFM receiver, exactly like a PC terminal would.
-- The lab version of this testbench only printed what it saw; this one
-- checks the received text.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

use work.uart_bfm_pkg.all;

entity tb_serial_text_transmitter is
  generic (
    runner_cfg : string;
    CLK_FREQ   : positive := 50_000_000;
    BAUD       : positive := 9_600
  );
end entity tb_serial_text_transmitter;

architecture tb of tb_serial_text_transmitter is
  constant MESSAGE      : string   := "HELLO!" & CR & LF;
  constant CLK_PERIOD   : time     := 1 sec / CLK_FREQ;
  constant CLKS_PER_BIT : positive := (CLK_FREQ + BAUD / 2) / BAUD;
  constant BIT_TIME     : time     := CLKS_PER_BIT * CLK_PERIOD;
  constant FRAME_TIME   : time     := 10 * BIT_TIME;

  signal clk   : std_logic := '0';
  signal reset : std_logic := '1';
  signal tx    : std_logic;

  constant received : queue_t := new_queue;
begin

  clk <= not clk after CLK_PERIOD / 2;

  u_dut : entity work.serial_text_transmitter
    generic map (CLK_FREQ => CLK_FREQ, BAUD => BAUD, MESSAGE => MESSAGE)
    port map (clk => clk, reset => reset, tx => tx);

  terminal : process                               -- the "PC" on the other end
    variable data    : std_logic_vector(7 downto 0);
    variable stop_ok : boolean;
  begin
    uart_receive(tx, BIT_TIME, data, stop_ok);
    check_true(stop_ok, "stop bit of " & printable(data));
    push(received, to_integer(unsigned(data)));
  end process terminal;

  main : process
    procedure expect_text (text : string) is
      variable ch : natural;
    begin
      for i in text'range loop
        for t in 1 to 3 loop                       -- up to 3 frame times per char
          exit when not is_empty(received);
          wait for FRAME_TIME;
        end loop;
        check_false(is_empty(received), "character " & to_string(i) & " never arrived");
        ch := pop_integer(received);
        check_equal(ch, character'pos(text(i)),
                    "character " & to_string(i) & ": got " &
                    printable(std_logic_vector(to_unsigned(ch, 8))));
      end loop;
    end procedure;
  begin
    test_runner_setup(runner, runner_cfg);

    while test_suite loop
      reset <= '1';
      wait for 10 * CLK_PERIOD;
      reset <= '0';

      if run("sends_message_repeatedly") then
        expect_text(MESSAGE & MESSAGE);
        info("received """ & "HELLO!" & """ + CR LF twice");

      elsif run("reset_restarts_the_message") then
        expect_text("HEL");
        reset <= '1';                              -- press reset mid-message
        wait for 2 * FRAME_TIME;                   -- let the terminal finish
        flush(received);                           -- drop the truncated frame
        reset <= '0';
        expect_text(MESSAGE);                      -- starts again at 'H'
      end if;
    end loop;

    test_runner_cleanup(runner);
  end process main;

end architecture tb;
