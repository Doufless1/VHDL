--------------------------------------------------------------------------------
-- two_bit_adder : 2-bit adder written as gate-level boolean equations
--
-- Week-1 lab, the first design taken to the MAX 10 board (switches -> LEDs).
-- Based on the course template by J.S.D. Stokkink (Saxion, 2014).
--
--   {carry, sum1, sum0} = {a1, a0} + {b1, b0}
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity two_bit_adder is
  port (
    a0, a1 : in  std_logic;   -- operand A (a1 = MSB)
    b0, b1 : in  std_logic;   -- operand B (b1 = MSB)
    sum0   : out std_logic;
    sum1   : out std_logic;
    carry  : out std_logic
  );
end entity two_bit_adder;

architecture dataflow of two_bit_adder is
  signal c1 : std_logic;      -- carry from bit 0 into bit 1
begin
  -- bit 0: half adder
  sum0  <= a0 xor b0;
  c1    <= a0 and b0;
  -- bit 1: full adder (carry-out is the majority function of a1, b1, c1)
  sum1  <= a1 xor b1 xor c1;
  carry <= (a1 and b1) or (c1 and a1) or (c1 and b1);
end architecture dataflow;
