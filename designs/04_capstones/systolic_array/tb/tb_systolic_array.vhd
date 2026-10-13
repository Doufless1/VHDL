--------------------------------------------------------------------------------
-- tb_systolic_array : bit-exact check against the NumPy golden model
--
-- Before each run, VUnit calls scripts/gemm_golden.py, which writes the vector
-- file for this ROWS x COLS configuration into the test's output directory.
-- The file is already in beat order, so the driver just streams it:
--
--   gemm_vectors.txt --> driver --(valid/ready)--> systolic_array
--                          |                            |
--                          +--> scoreboard (C, K, t0) --> checker
--
-- The checker compares every element of every result tile and, when no
-- bubbles are inserted, the exact cycle count K + ROWS + COLS - 1.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

library vunit_lib;
context vunit_lib.vunit_context;

library osvvm;
use osvvm.RandomPkg.all;

entity tb_systolic_array is
  generic (
    runner_cfg : string;
    ROWS       : positive := 4;
    COLS       : positive := 4
  );
end entity tb_systolic_array;

architecture tb of tb_systolic_array is
  constant DATA_WIDTH : positive := 8;
  constant ACC_WIDTH  : positive := 32;
  constant CLK_PERIOD : time     := 10 ns;

  signal clk       : std_logic := '0';
  signal rst       : std_logic := '1';
  signal in_valid  : std_logic := '0';
  signal in_ready  : std_logic;
  signal in_last   : std_logic := '0';
  signal a_col     : std_logic_vector(ROWS * DATA_WIDTH - 1 downto 0) := (others => '0');
  signal b_row     : std_logic_vector(COLS * DATA_WIDTH - 1 downto 0) := (others => '0');
  signal out_valid : std_logic;
  signal c_mat     : std_logic_vector(ROWS * COLS * ACC_WIDTH - 1 downto 0);

  signal cycle       : natural := 0;
  signal bubbles     : boolean := false;
  signal tiles_done  : natural := 0;
  constant scoreboard : queue_t := new_queue;   -- per tile: K, t0, C(0,0) .. C(R-1,C-1)

  -- next integer from the vector file, skipping '#' comment lines
  procedure next_int (file f : text; variable buf : inout line; variable value : out integer) is
    variable ok : boolean;
    variable ch : character;
  begin
    loop
      while buf /= null and buf'length > 0 and buf(buf'left) = ' ' loop
        read(buf, ch);
      end loop;
      if buf = null or buf'length = 0 or buf(buf'left) = '#' then
        assert not endfile(f) report "unexpected end of vector file" severity failure;
        readline(f, buf);
      else
        read(buf, value, ok);
        assert ok report "malformed integer in vector file" severity failure;
        return;
      end if;
    end loop;
  end procedure;

begin

  clk <= not clk after CLK_PERIOD / 2;

  cycle_counter : process
  begin
    wait until rising_edge(clk);
    cycle <= cycle + 1;
  end process;

  u_dut : entity work.systolic_array
    generic map (ROWS => ROWS, COLS => COLS, DATA_WIDTH => DATA_WIDTH, ACC_WIDTH => ACC_WIDTH)
    port map (clk => clk, rst => rst, in_valid => in_valid, in_ready => in_ready,
              in_last => in_last, a_col => a_col, b_row => b_row,
              out_valid => out_valid, c_mat => c_mat);

  ------------------------------------------------------------------------------
  checker : process
    variable k, t0, expected, got : integer;
  begin
    wait until rising_edge(clk) and out_valid = '1';
    check_false(is_empty(scoreboard), "result without a tile");
    k  := pop_integer(scoreboard);
    t0 := pop_integer(scoreboard);
    if not bubbles then
      check_equal(cycle - t0, k + ROWS + COLS - 1,
                  "cycles from first beat to result, K=" & to_string(k));
    end if;
    for i in 0 to ROWS - 1 loop
      for j in 0 to COLS - 1 loop
        expected := pop_integer(scoreboard);
        got := to_integer(signed(c_mat((i * COLS + j + 1) * ACC_WIDTH - 1 downto (i * COLS + j) * ACC_WIDTH)));
        check_equal(got, expected, "tile " & to_string(tiles_done) & " C(" &
                    to_string(i) & "," & to_string(j) & "), K=" & to_string(k));
      end loop;
    end loop;
    tiles_done <= tiles_done + 1;
  end process checker;

  ------------------------------------------------------------------------------
  driver : process
    file     vectors : text;
    variable buf     : line;
    variable rnd     : RandomPType;
    variable n_tiles, k, value, t0 : integer;
    variable macs    : natural := 0;
  begin
    test_runner_setup(runner, runner_cfg);
    rnd.InitSeed(rnd'instance_name);

    rst <= '1';
    wait for 4 * CLK_PERIOD;
    wait until rising_edge(clk);
    rst <= '0';

    while test_suite loop
      if run("golden_vectors_bit_exact") then
        bubbles <= false;
      elsif run("golden_vectors_with_random_bubbles") then
        bubbles <= true;
      end if;
      wait for 0 ns;

      file_open(vectors, output_path(runner_cfg) & "gemm_vectors.txt", read_mode);
      next_int(vectors, buf, n_tiles);
      info(to_string(ROWS) & "x" & to_string(COLS) & " array, " &
           to_string(n_tiles) & " golden tiles");

      for t in 0 to n_tiles - 1 loop
        next_int(vectors, buf, k);
        for beat in 0 to k - 1 loop
          if bubbles then                            -- random gaps in the stream
            for idle in 1 to rnd.DistInt((6, 3, 1)) loop
              in_valid <= '0';
              wait until rising_edge(clk);
            end loop;
          end if;
          for i in 0 to ROWS - 1 loop
            next_int(vectors, buf, value);
            a_col((i + 1) * DATA_WIDTH - 1 downto i * DATA_WIDTH) <= std_logic_vector(to_signed(value, DATA_WIDTH));
          end loop;
          for j in 0 to COLS - 1 loop
            next_int(vectors, buf, value);
            b_row((j + 1) * DATA_WIDTH - 1 downto j * DATA_WIDTH) <= std_logic_vector(to_signed(value, DATA_WIDTH));
          end loop;
          in_valid <= '1';
          in_last  <= '1' when beat = k - 1 else '0';
          wait until rising_edge(clk) and in_ready = '1';   -- beat accepted here
          if beat = 0 then
            t0 := cycle;
          end if;
        end loop;
        in_valid <= '0';
        in_last  <= '0';

        push(scoreboard, k);                          -- expected result of this tile
        push(scoreboard, t0);
        for n in 1 to ROWS * COLS loop
          next_int(vectors, buf, value);
          push(scoreboard, value);
        end loop;
        macs := macs + k * ROWS * COLS;
      end loop;
      file_close(vectors);

      wait until rising_edge(clk) and in_ready = '1';   -- last result delivered
      wait until rising_edge(clk);
      check_equal(tiles_done, n_tiles, "every tile produced a result");
      info("verified " & to_string(macs) & " multiply-accumulates in " &
           to_string(n_tiles) & " tiles, bit-exact");
    end loop;

    test_runner_cleanup(runner);
  end process driver;

end architecture tb;
