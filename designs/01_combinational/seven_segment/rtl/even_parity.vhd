--------------------------------------------------------------------------------
-- even_parity : even-parity bit generator
--
-- parity = XOR of all data bits, so that data & parity together always hold
-- an even number of ones. A receiver that recomputes the XOR over data and
-- parity gets '0' for a good word and '1' when a single bit flipped.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity even_parity is
  generic (
    WIDTH : positive := 4
  );
  port (
    data   : in  std_logic_vector(WIDTH - 1 downto 0);
    parity : out std_logic
  );
end entity even_parity;

architecture behavioral of even_parity is
begin
  process (data)
    variable p : std_logic;
  begin
    p := '0';
    for i in data'range loop
      p := p xor data(i);
    end loop;
    parity <= p;
  end process;
end architecture behavioral;
