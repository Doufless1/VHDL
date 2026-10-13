--------------------------------------------------------------------------------
-- systolic_array : ROWS x COLS output-stationary systolic array, INT8 GEMM
--
-- Computes C = A x B for A (ROWS x K) and B (K x COLS), for any depth K.
--
--                 B(k,0)   B(k,1)   B(k,2)     Beat k carries column k of A
--                   |      z^-1     z^-2       and row k of B. Row i of A is
--                   v        v        v        delayed by i cycles and column
--   A(0,k) ------> PE -----> PE -----> PE      j of B by j cycles (input
--   A(1,k) -z^-1-> PE -----> PE -----> PE      skew), so A(i,k) and B(k,j)
--   A(2,k) -z^-2-> PE -----> PE -----> PE      meet in PE(i,j) together.
--
-- PE(i,j) accumulates C(i,j) = sum_k A(i,k) * B(k,j) in place (output-
-- stationary). Each A element is used by COLS PEs and each B element by ROWS
-- PEs while travelling only one register per clock: ROWS*COLS MACs per cycle
-- from ROWS+COLS operands per cycle.
--
-- Protocol (valid/ready, AXI4-Stream style):
--   * a beat is taken on a rising edge with in_valid = in_ready = '1';
--     in_last marks beat K-1. Bubbles (in_valid = '0' mid-tile) are allowed.
--   * after the last beat the array drains with in_ready = '0'; out_valid
--     then pulses for one cycle with C in c_mat and in_ready returns, so the
--     next tile can start in that same cycle.
--   * c_mat stays valid until the next tile's first beat reaches the PEs.
-- Without bubbles the result is captured K + ROWS + COLS - 1 cycles after
-- the first beat; that is also the tile period (see README for utilization).
--
-- Packing: A(i,k) = a_col slice i,  B(k,j) = b_row slice j,
--          C(i,j) = c_mat slice i*COLS + j    (slice n = bits n*W+W-1 .. n*W)
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity systolic_array is
  generic (
    ROWS       : positive := 4;
    COLS       : positive := 4;
    DATA_WIDTH : positive := 8;      -- INT8 operands
    ACC_WIDTH  : positive := 32      -- INT32 results
  );
  port (
    clk       : in  std_logic;
    rst       : in  std_logic;                                        -- synchronous
    in_valid  : in  std_logic;
    in_ready  : out std_logic;
    in_last   : in  std_logic;
    a_col     : in  std_logic_vector(ROWS * DATA_WIDTH - 1 downto 0);
    b_row     : in  std_logic_vector(COLS * DATA_WIDTH - 1 downto 0);
    out_valid : out std_logic;
    c_mat     : out std_logic_vector(ROWS * COLS * ACC_WIDTH - 1 downto 0)
  );
end entity systolic_array;

architecture rtl of systolic_array is
  subtype data_t is std_logic_vector(DATA_WIDTH - 1 downto 0);
  type data_array_t is array (natural range <>) of data_t;
  type data_grid_t  is array (natural range <>, natural range <>) of data_t;
  type tag_grid_t   is array (natural range <>, natural range <>) of std_logic;

  -- signals entering PE(i,j) from the left (A path, with tags) and from the
  -- top (B path); column COLS and row ROWS are the unused outputs of the edge
  signal a_h     : data_grid_t(0 to ROWS - 1, 0 to COLS);
  signal valid_h : tag_grid_t(0 to ROWS - 1, 0 to COLS);
  signal first_h : tag_grid_t(0 to ROWS - 1, 0 to COLS);
  signal b_v     : data_grid_t(0 to ROWS, 0 to COLS - 1);

  signal accept    : std_logic;
  signal first_tag : std_logic;
  signal loading   : std_logic := '0';   -- inside a tile (first beat taken)
  signal draining  : std_logic := '0';   -- last beat taken, results pending

  -- The last product is accumulated by PE(ROWS-1, COLS-1) ROWS + COLS - 1
  -- edges after the last beat is accepted; done_pipe counts those edges.
  constant DONE_DEPTH : positive := ROWS + COLS;
  signal done_pipe : std_logic_vector(0 to DONE_DEPTH - 1) := (others => '0');

begin

  ------------------------------------------------------------------------------
  -- Tile control
  ------------------------------------------------------------------------------
  accept    <= in_valid and not draining;
  first_tag <= accept and not loading;

  control : process (clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        loading   <= '0';
        draining  <= '0';
        done_pipe <= (others => '0');
      else
        done_pipe <= (accept and in_last) & done_pipe(0 to DONE_DEPTH - 2);
        if accept = '1' then
          if in_last = '1' then
            loading  <= '0';
            draining <= '1';
          else
            loading  <= '1';
          end if;
        end if;
        -- reopen the input together with out_valid (one stage early)
        if done_pipe(DONE_DEPTH - 2) = '1' then
          draining <= '0';
        end if;
      end if;
    end if;
  end process control;

  in_ready  <= not draining;
  out_valid <= done_pipe(DONE_DEPTH - 1);

  ------------------------------------------------------------------------------
  -- Input skew: row i of A (with its tags) is delayed by i extra cycles
  ------------------------------------------------------------------------------
  gen_skew_a : for i in 0 to ROWS - 1 generate
    signal data_pipe  : data_array_t(0 to i);
    signal valid_pipe : std_logic_vector(0 to i) := (others => '0');
    signal first_pipe : std_logic_vector(0 to i) := (others => '0');
  begin
    process (clk)
    begin
      if rising_edge(clk) then
        data_pipe(0) <= a_col((i + 1) * DATA_WIDTH - 1 downto i * DATA_WIDTH);
        for s in 1 to i loop
          data_pipe(s) <= data_pipe(s - 1);
        end loop;
        if rst = '1' then
          valid_pipe <= (others => '0');
          first_pipe <= (others => '0');
        else
          valid_pipe(0) <= accept;
          first_pipe(0) <= first_tag;
          for s in 1 to i loop
            valid_pipe(s) <= valid_pipe(s - 1);
            first_pipe(s) <= first_pipe(s - 1);
          end loop;
        end if;
      end if;
    end process;

    a_h(i, 0)     <= data_pipe(i);
    valid_h(i, 0) <= valid_pipe(i);
    first_h(i, 0) <= first_pipe(i);
  end generate gen_skew_a;

  -- column j of B is delayed by j extra cycles
  gen_skew_b : for j in 0 to COLS - 1 generate
    signal data_pipe : data_array_t(0 to j);
  begin
    process (clk)
    begin
      if rising_edge(clk) then
        data_pipe(0) <= b_row((j + 1) * DATA_WIDTH - 1 downto j * DATA_WIDTH);
        for s in 1 to j loop
          data_pipe(s) <= data_pipe(s - 1);
        end loop;
      end if;
    end process;

    b_v(0, j) <= data_pipe(j);
  end generate gen_skew_b;

  ------------------------------------------------------------------------------
  -- PE grid
  ------------------------------------------------------------------------------
  gen_row : for i in 0 to ROWS - 1 generate
    gen_col : for j in 0 to COLS - 1 generate
      u_pe : entity work.mac_pe
        generic map (
          DATA_WIDTH => DATA_WIDTH,
          ACC_WIDTH  => ACC_WIDTH
        )
        port map (
          clk       => clk,
          rst       => rst,
          valid_in  => valid_h(i, j),
          first_in  => first_h(i, j),
          a_in      => a_h(i, j),
          b_in      => b_v(i, j),
          valid_out => valid_h(i, j + 1),
          first_out => first_h(i, j + 1),
          a_out     => a_h(i, j + 1),
          b_out     => b_v(i + 1, j),
          acc       => c_mat((i * COLS + j + 1) * ACC_WIDTH - 1 downto (i * COLS + j) * ACC_WIDTH)
        );
    end generate gen_col;
  end generate gen_row;

end architecture rtl;
