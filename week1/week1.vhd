-- designer J.S.D. Stokkink
-- december 2014

-- function 2 inputs a and b are added , both have two bits , a0 a1, b0 b1.
-- output sum (sum0 sum1 and carry)

-- for board "Danjel"
-- input a0 IO45 pin 51
-- input a1 IO43 pin 52
-- input b0 IO41 pin 53
-- input b1 IO40 pin 54
-- output sum0 LED pin 83
-- output sum1 LED pin 82
-- output carry LED pin 81

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY week1 is   -- THE NAME "adder" must be the same as the file name
PORT ( a0,a1,b0,b1 : IN std_logic;
       sum0,sum1,carry : OUT std_logic);
END week1;

ARCHITECTURE behaviour OF week1 is
signal c1: std_logic;

BEGIN
    sum0 <= a0 XOR b0;
    c1   <= (a0 AND b0);
    sum1 <= a1 XOR b1 XOR c1;
    carry <= (a1 AND b1) OR (c1 AND a1) OR (c1 AND b1);

END behaviour;