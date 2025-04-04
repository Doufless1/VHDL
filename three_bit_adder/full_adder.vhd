LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY full_adder IS
    PORT (
        A, B, Cin : IN std_logic;
        Sum, Cout : OUT std_logic
    );
END full_adder;

ARCHITECTURE behavior OF full_adder IS
BEGIN
    Sum  <= A XOR B XOR Cin;
    Cout <= (A AND B) OR (Cin AND (A XOR B));
END behavior;
