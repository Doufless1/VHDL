--------------------------------------------------------------------------------
-- full_adder : 1-bit full adder, the building block of ripple_carry_adder
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity full_adder is
  port (
    a, b : in  std_logic;
    cin  : in  std_logic;
    sum  : out std_logic;
    cout : out std_logic
  );
end entity full_adder;

architecture dataflow of full_adder is
begin
  sum  <= a xor b xor cin;
  cout <= (a and b) or (cin and (a xor b));
end architecture dataflow;
