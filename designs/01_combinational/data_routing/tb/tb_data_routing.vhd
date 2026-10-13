--------------------------------------------------------------------------------
-- tb_data_routing : self-checking tests for mux_4to1, demux_1to4,
-- decoder_2to4 and tristate_buffer
--
-- The combinational blocks are tested exhaustively. The tri-state test puts
-- two buffers and a pull-up resistor on one bus and checks the std_logic
-- resolution: released bus -> 'H', one driver -> its value, two drivers that
-- disagree -> 'X' (bus contention).
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_data_routing is
  generic (
    runner_cfg : string
  );
end entity tb_data_routing;

architecture tb of tb_data_routing is
  -- mux / demux
  signal d                    : std_logic_vector(3 downto 0) := (others => '0');
  signal s                    : std_logic_vector(1 downto 0) := (others => '0');
  signal mux_y                : std_logic;
  signal demux_d              : std_logic := '0';
  signal y0, y1, y2, y3       : std_logic;
  signal rt_y0, rt_y1, rt_y2, rt_y3, rt_y : std_logic;   -- demux -> mux round trip
  -- decoder
  signal dec_a                : std_logic_vector(1 downto 0) := (others => '0');
  signal dec_y                : std_logic_vector(3 downto 0);
  -- tri-state bus
  signal data_a, data_b       : std_logic_vector(7 downto 0) := (others => '0');
  signal oe_a_n, oe_b_n       : std_logic := '1';
  signal shared_bus           : std_logic_vector(7 downto 0);
begin

  u_mux : entity work.mux_4to1
    port map (d0 => d(0), d1 => d(1), d2 => d(2), d3 => d(3), s => s, y => mux_y);

  u_demux : entity work.demux_1to4
    port map (d => demux_d, s => s, y0 => y0, y1 => y1, y2 => y2, y3 => y3);

  -- round trip: demux the bit out, multiplex it back with the same select
  u_rt_demux : entity work.demux_1to4
    port map (d => demux_d, s => s, y0 => rt_y0, y1 => rt_y1, y2 => rt_y2, y3 => rt_y3);
  u_rt_mux : entity work.mux_4to1
    port map (d0 => rt_y0, d1 => rt_y1, d2 => rt_y2, d3 => rt_y3, s => s, y => rt_y);

  u_decoder : entity work.decoder_2to4
    port map (a => dec_a, y => dec_y);

  u_tri_a : entity work.tristate_buffer
    generic map (WIDTH => 8)
    port map (a => data_a, oe_n => oe_a_n, bus_io => shared_bus);
  u_tri_b : entity work.tristate_buffer
    generic map (WIDTH => 8)
    port map (a => data_b, oe_n => oe_b_n, bus_io => shared_bus);

  shared_bus <= (others => 'H');           -- weak pull-up resistor on the bus

  main : process
    variable sel      : natural;
    variable expected : std_logic_vector(3 downto 0);
  begin
    test_runner_setup(runner, runner_cfg);

    while test_suite loop

      if run("mux_4to1_exhaustive") then
        for data in 0 to 15 loop
          for sv in 0 to 3 loop
            d <= std_logic_vector(to_unsigned(data, 4));
            s <= std_logic_vector(to_unsigned(sv, 2));
            wait for 1 ns;
            check_equal(mux_y, d(sv), "mux d=" & to_string(d) & " s=" & to_string(sv));
          end loop;
        end loop;

      elsif run("demux_1to4_exhaustive") then
        for data in 0 to 1 loop
          for sv in 0 to 3 loop
            demux_d <= '1' when data = 1 else '0';
            s       <= std_logic_vector(to_unsigned(sv, 2));
            wait for 1 ns;
            expected     := (others => '0');
            expected(sv) := demux_d;
            check_equal(std_logic_vector'(y3 & y2 & y1 & y0), expected,
                        "demux d=" & to_string(data) & " s=" & to_string(sv));
          end loop;
        end loop;

      elsif run("demux_then_mux_is_identity") then
        for data in 0 to 1 loop
          for sv in 0 to 3 loop
            demux_d <= '1' when data = 1 else '0';
            s       <= std_logic_vector(to_unsigned(sv, 2));
            wait for 1 ns;
            check_equal(rt_y, demux_d, "round trip s=" & to_string(sv));
          end loop;
        end loop;

      elsif run("decoder_2to4_is_one_hot") then
        for av in 0 to 3 loop
          dec_a <= std_logic_vector(to_unsigned(av, 2));
          wait for 1 ns;
          expected     := (others => '0');
          expected(av) := '1';
          check_equal(dec_y, expected, "decoder a=" & to_string(av));
        end loop;

      elsif run("tristate_bus_sharing") then
        data_a <= x"A5";
        data_b <= x"3C";

        oe_a_n <= '1';  oe_b_n <= '1';     -- nobody drives: pull-up wins
        wait for 1 ns;
        check_equal(shared_bus, std_logic_vector'("HHHHHHHH"), "released bus");

        oe_a_n <= '0';  oe_b_n <= '1';     -- A owns the bus
        wait for 1 ns;
        check_equal(shared_bus, std_logic_vector'(x"A5"), "A drives");

        oe_a_n <= '1';  oe_b_n <= '0';     -- B owns the bus
        wait for 1 ns;
        check_equal(shared_bus, std_logic_vector'(x"3C"), "B drives");

        oe_a_n <= '0';  oe_b_n <= '0';     -- contention: bits that differ -> 'X'
        wait for 1 ns;                     -- A5 = 1010_0101, 3C = 0011_1100
        check_equal(shared_bus, std_logic_vector'("X01XX10X"), "contention");
        check_true(is_x(shared_bus), "contention must be visible as 'X'");
      end if;

    end loop;

    test_runner_cleanup(runner);
  end process main;

end architecture tb;
