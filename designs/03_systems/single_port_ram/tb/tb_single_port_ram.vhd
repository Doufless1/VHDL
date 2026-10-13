--------------------------------------------------------------------------------
-- tb_single_port_ram : self-checking test against a shadow-memory model
--
-- The testbench keeps its own copy of the memory (an integer array). Every
-- read is compared with the copy, so any lost, misplaced or corrupted write
-- is caught. Also pins down the two timing properties the RTL promises:
-- one clock of read latency and write-first read-during-write behaviour.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

library osvvm;
use osvvm.RandomPkg.all;

entity tb_single_port_ram is
  generic (
    runner_cfg : string;
    DATA_WIDTH : positive := 8;
    ADDR_WIDTH : positive := 6
  );
end entity tb_single_port_ram;

architecture tb of tb_single_port_ram is
  constant CLK_PERIOD : time    := 20 ns;
  constant DEPTH      : natural := 2**ADDR_WIDTH;

  signal clk  : std_logic := '0';
  signal we   : std_logic := '0';
  signal addr : std_logic_vector(ADDR_WIDTH - 1 downto 0) := (others => '0');
  signal din  : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
  signal dout : std_logic_vector(DATA_WIDTH - 1 downto 0);
begin

  clk <= not clk after CLK_PERIOD / 2;

  u_dut : entity work.single_port_ram
    generic map (DATA_WIDTH => DATA_WIDTH, ADDR_WIDTH => ADDR_WIDTH)
    port map (clk => clk, we => we, addr => addr, din => din, dout => dout);

  main : process
    type shadow_t is array (0 to DEPTH - 1) of natural;
    variable shadow : shadow_t := (others => 0);         -- RAM powers up zeroed
    variable rnd    : RandomPType;
    variable a, v   : natural;

    -- one clock cycle; inputs change on the falling edge
    procedure access_ram (write : boolean; address, value : natural) is
    begin
      wait until falling_edge(clk);
      we   <= '1' when write else '0';
      addr <= std_logic_vector(to_unsigned(address, ADDR_WIDTH));
      din  <= std_logic_vector(to_unsigned(value, DATA_WIDTH));
      if write then
        shadow(address) := value;
      end if;
      wait until rising_edge(clk);
      wait for 1 ns;
      -- dout now shows the word at `address` (registered address)
      check_equal(unsigned(dout), shadow(address),
                  "read data, address " & to_string(address));
    end procedure;
  begin
    test_runner_setup(runner, runner_cfg);
    rnd.InitSeed(rnd'instance_name);

    while test_suite loop

      if run("power_up_contents_are_zero") then
        for i in 0 to DEPTH - 1 loop
          access_ram(false, i, 0);
        end loop;

      elsif run("write_all_then_read_back") then
        for i in 0 to DEPTH - 1 loop
          access_ram(true, i, rnd.RandInt(0, 2**DATA_WIDTH - 1));
        end loop;
        for i in DEPTH - 1 downto 0 loop
          access_ram(false, i, 0);
        end loop;

      elsif run("read_latency_is_one_clock") then
        -- block RAM has a registered read: a new address must not show up
        -- on dout before the next rising edge (an asynchronous-read RAM would)
        access_ram(true, 1, 16#11#);
        access_ram(true, 2, 16#22#);
        access_ram(false, 1, 0);                -- dout = mem(1)
        wait until falling_edge(clk);
        addr <= std_logic_vector(to_unsigned(2, ADDR_WIDTH));
        wait for CLK_PERIOD / 4;                -- still before the rising edge
        check_equal(unsigned(dout), 16#11#, "dout must hold until the clock edge");
        wait until rising_edge(clk);
        wait for 1 ns;
        check_equal(unsigned(dout), 16#22#, "new address one edge later");

      elsif run("read_during_write_returns_new_data") then
        access_ram(true, 5, 16#11#);
        access_ram(true, 5, 16#22#);       -- check inside access_ram expects 0x22
        check_equal(unsigned(dout), 16#22#, "write-first behaviour");

      elsif run("write_enable_low_does_not_write") then
        access_ram(true, 9, 16#5A#);
        wait until falling_edge(clk);
        we   <= '0';
        din  <= std_logic_vector(to_unsigned(16#A5#, DATA_WIDTH));
        wait until rising_edge(clk);
        access_ram(false, 9, 0);           -- must still read 0x5A

      elsif run("random_reads_and_writes") then
        for i in 1 to 5000 loop
          a := rnd.RandInt(0, DEPTH - 1);
          v := rnd.RandInt(0, 2**DATA_WIDTH - 1);
          access_ram(rnd.RandInt(0, 1) = 1, a, v);
        end loop;
      end if;

    end loop;

    test_runner_cleanup(runner);
  end process main;

end architecture tb;
