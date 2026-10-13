--------------------------------------------------------------------------------
-- mac_pe : processing element (PE) of the output-stationary systolic array
--
--                    b_in
--                     |
--          a_in  +----v-----------------+  a_out      every clock:
--  valid/first ->|  acc += a_in * b_in  |-> valid/first   a, b, tags move on
--                +----+-----------------+                 by one register
--                     |
--                    b_out
--
-- * INT8 x INT8 -> INT32 multiply-accumulate (generic widths).
-- * No global clear: a `first` tag travels with the A operand and makes the
--   PE start a new sum (acc := a*b) instead of adding to the old one. Every
--   PE therefore restarts exactly when its first operand arrives - no
--   high-fanout broadcast net, which is what lets large arrays close timing.
-- * Only the control tags are reset; datapath registers are not (a common
--   FPGA practice: less reset routing, and their values are only used when
--   a valid tag accompanies them).
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mac_pe is
  generic (
    DATA_WIDTH : positive := 8;    -- signed operand width (INT8)
    ACC_WIDTH  : positive := 32    -- signed accumulator width (INT32)
  );
  port (
    clk       : in  std_logic;
    rst       : in  std_logic;                                -- synchronous
    valid_in  : in  std_logic;    -- a_in and b_in form a matching pair
    first_in  : in  std_logic;    -- first pair of a new dot product
    a_in      : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
    b_in      : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
    valid_out : out std_logic;
    first_out : out std_logic;
    a_out     : out std_logic_vector(DATA_WIDTH - 1 downto 0);
    b_out     : out std_logic_vector(DATA_WIDTH - 1 downto 0);
    acc       : out std_logic_vector(ACC_WIDTH - 1 downto 0)
  );
end entity mac_pe;

architecture rtl of mac_pe is
  signal valid_reg : std_logic := '0';
  signal first_reg : std_logic := '0';
  signal a_reg     : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
  signal b_reg     : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
  signal acc_reg   : signed(ACC_WIDTH - 1 downto 0) := (others => '0');
begin

  process (clk)
    variable product : signed(2 * DATA_WIDTH - 1 downto 0);
  begin
    if rising_edge(clk) then
      -- systolic forwarding
      a_reg <= a_in;
      b_reg <= b_in;
      if rst = '1' then
        valid_reg <= '0';
        first_reg <= '0';
      else
        valid_reg <= valid_in;
        first_reg <= first_in;
      end if;

      -- multiply-accumulate
      product := signed(a_in) * signed(b_in);
      if valid_in = '1' and rst = '0' then
        if first_in = '1' then
          acc_reg <= resize(product, ACC_WIDTH);
        else
          acc_reg <= acc_reg + resize(product, ACC_WIDTH);
        end if;
      end if;
    end if;
  end process;

  valid_out <= valid_reg;
  first_out <= first_reg;
  a_out     <= a_reg;
  b_out     <= b_reg;
  acc       <= std_logic_vector(acc_reg);

end architecture rtl;
