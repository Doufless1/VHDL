--------------------------------------------------------------------------------
-- tb_d_register : self-checking test of the negative-edge register
--
-- Checks the three properties that define the lab design: data is captured
-- on the falling edge only, the reset works without any clock, and reset
-- dominates the clock. Random data comes from OSVVM's RandomPkg.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

library osvvm;
use osvvm.RandomPkg.all;

entity tb_d_register is
  generic (
    runner_cfg : string;
    WIDTH      : positive := 8
  );
end entity tb_d_register;

architecture tb of tb_d_register is
  constant CLK_PERIOD : time := 20 ns;          -- 50 MHz

  signal clk_en : boolean := true;
  signal clk    : std_logic := '0';
  signal arst   : std_logic := '1';
  signal d, q   : std_logic_vector(WIDTH - 1 downto 0) := (others => '0');

  constant ZERO : std_logic_vector(WIDTH - 1 downto 0) := (others => '0');
begin

  clk <= not clk after CLK_PERIOD / 2 when clk_en else unaffected;

  u_dut : entity work.d_register
    generic map (WIDTH => WIDTH)
    port map (clk => clk, arst => arst, d => d, q => q);

  main : process
    variable rnd      : RandomPType;
    variable expected : std_logic_vector(WIDTH - 1 downto 0);
    variable previous : std_logic_vector(WIDTH - 1 downto 0);
  begin
    test_runner_setup(runner, runner_cfg);
    rnd.InitSeed(rnd'instance_name);

    while test_suite loop
      arst   <= '1';
      clk_en <= true;
      wait for 3 * CLK_PERIOD;
      check_equal(q, ZERO, "reset value");
      arst   <= '0';

      if run("captures_on_falling_edge_only") then
        for i in 1 to 20 loop
          wait until falling_edge(clk);
          wait for 1 ns;
          previous := q;
          expected := rnd.RandSlv(WIDTH);
          if expected = previous then           -- make the check meaningful
            expected := not previous;
          end if;
          d <= expected;
          wait until rising_edge(clk);          -- a rising edge must not load d
          wait for 1 ns;
          check_equal(q, previous, "q must not change on a rising edge");
          wait until falling_edge(clk);         -- the falling edge must load d
          wait for 1 ns;
          check_equal(q, expected, "q after falling edge");
        end loop;

      elsif run("async_reset_without_clock") then
        d <= not ZERO;
        wait until falling_edge(clk);
        wait for 1 ns;
        check_equal(q, not ZERO, "q loaded before reset");
        clk_en <= false;                        -- stop the clock completely
        wait for 5 * CLK_PERIOD;
        arst <= '1';
        wait for 1 ns;
        check_equal(q, ZERO, "asynchronous reset must clear q with no clock edge");

      elsif run("reset_dominates_clock") then
        arst <= '1';
        d    <= not ZERO;
        for i in 1 to 5 loop
          wait until falling_edge(clk);
          wait for 1 ns;
          check_equal(q, ZERO, "q must stay zero while reset is active");
        end loop;

      elsif run("random_data_1000_cycles") then
        for i in 1 to 1000 loop
          wait until rising_edge(clk);
          expected := rnd.RandSlv(WIDTH);
          d <= expected;
          wait until falling_edge(clk);
          wait for 1 ns;
          check_equal(q, expected, "cycle " & to_string(i));
        end loop;
      end if;
    end loop;

    test_runner_cleanup(runner);
  end process main;

end architecture tb;
