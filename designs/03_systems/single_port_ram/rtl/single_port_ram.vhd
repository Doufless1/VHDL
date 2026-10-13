--------------------------------------------------------------------------------
-- single_port_ram : synchronous single-port RAM that infers FPGA block RAM
--
-- Written in the coding style synthesis tools recognise as block RAM
-- (MAX 10: M9K). The *address* is registered and the array is read with the
-- registered address, which gives:
--   * read latency of one clock: dout shows ram(addr) one edge after addr
--   * read-during-write returns the NEW data ("write-first" behaviour)
-- Default size 64 x 8 bit = the lab configuration (512 memory bits).
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity single_port_ram is
  generic (
    DATA_WIDTH : positive := 8;
    ADDR_WIDTH : positive := 6     -- depth = 2**ADDR_WIDTH words
  );
  port (
    clk  : in  std_logic;
    we   : in  std_logic;                                   -- write enable
    addr : in  std_logic_vector(ADDR_WIDTH - 1 downto 0);
    din  : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
    dout : out std_logic_vector(DATA_WIDTH - 1 downto 0)
  );
end entity single_port_ram;

architecture rtl of single_port_ram is
  type ram_t is array (0 to 2**ADDR_WIDTH - 1) of std_logic_vector(DATA_WIDTH - 1 downto 0);
  signal ram      : ram_t := (others => (others => '0'));
  signal addr_reg : std_logic_vector(ADDR_WIDTH - 1 downto 0) := (others => '0');
begin

  process (clk)
  begin
    if rising_edge(clk) then
      if we = '1' then
        ram(to_integer(unsigned(addr))) <= din;
      end if;
      addr_reg <= addr;
    end if;
  end process;

  dout <= ram(to_integer(unsigned(addr_reg)));

end architecture rtl;
