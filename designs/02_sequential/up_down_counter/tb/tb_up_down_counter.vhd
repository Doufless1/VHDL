--------------------------------------------------------------------------------
-- tb_up_down_counter : self-checking test against a reference model
--
-- The model is an integer that is incremented / decremented modulo 2**WIDTH.
-- Inputs change on the falling edge (half a period away from the active
-- rising edge) and the output is compared with the model every cycle.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

library osvvm;
use osvvm.RandomPkg.all;

entity tb_up_down_counter is
  generic (
    runner_cfg : string;
    WIDTH      : positive := 8
  );
end entity tb_up_down_counter;

architecture tb of tb_up_down_counter is
  constant CLK_PERIOD : time    := 20 ns;
  constant MODULUS    : natural := 2**WIDTH;

  signal clk     : std_logic := '0';
  signal arst    : std_logic := '1';
  signal enable  : std_logic := '0';
  signal up_down : std_logic := '1';
  signal count   : std_logic_vector(WIDTH - 1 downto 0);
begin

  clk <= not clk after CLK_PERIOD / 2;

  u_dut : entity work.up_down_counter
    generic map (WIDTH => WIDTH)
    port map (clk => clk, arst => arst, enable => enable, up_down => up_down, count => count);

  main : process
    variable rnd   : RandomPType;
    variable model : natural := 0;

    -- drive inputs for one clock cycle and advance the model accordingly
    procedure cycle (en, up : std_logic) is
    begin
      enable  <= en;
      up_down <= up;
      wait until falling_edge(clk);
      if en = '1' then
        if up = '1' then
          model := (model + 1) mod MODULUS;
        else
          model := (model + MODULUS - 1) mod MODULUS;
        end if;
      end if;
      check_equal(unsigned(count), model, "count");
    end procedure;
  begin
    test_runner_setup(runner, runner_cfg);
    rnd.InitSeed(rnd'instance_name);

    while test_suite loop
      arst <= '1';
      wait until falling_edge(clk);
      check_equal(unsigned(count), 0, "reset value");
      arst  <= '0';
      model := 0;

      if run("counts_up_and_wraps") then
        for i in 1 to MODULUS + 3 loop
          cycle('1', '1');
        end loop;

      elsif run("counts_down_and_wraps") then
        for i in 1 to MODULUS + 3 loop
          cycle('1', '0');
        end loop;

      elsif run("disabled_counter_holds") then
        for i in 1 to 5 loop
          cycle('1', '1');
        end loop;
        for i in 1 to 20 loop
          cycle('0', rnd.RandSl);
        end loop;

      elsif run("random_against_model") then
        for i in 1 to 5000 loop
          cycle(rnd.RandSl, rnd.RandSl);
        end loop;

      elsif run("async_reset_mid_count") then
        for i in 1 to 10 loop
          cycle('1', '1');
        end loop;
        wait for CLK_PERIOD / 4;                 -- between clock edges
        arst <= '1';
        wait for 1 ns;
        check_equal(unsigned(count), 0, "reset must act without a clock edge");
      end if;
    end loop;

    test_runner_cleanup(runner);
  end process main;

end architecture tb;
