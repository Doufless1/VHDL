LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY three_bit_adder IS
    PORT (
        A, B : IN std_logic_vector(2 DOWNTO 0);
        Cin  : IN std_logic;
        Sum  : OUT std_logic_vector(2 DOWNTO 0);
        Cout : OUT std_logic
    );
END three_bit_adder;

ARCHITECTURE structural OF three_bit_adder IS
    COMPONENT full_adder
        PORT (
            A, B, Cin : IN std_logic;
            Sum, Cout : OUT std_logic
        );
    END COMPONENT;
    
    SIGNAL C1, C2 : std_logic;
BEGIN
    FA0: full_adder PORT MAP (A(0), B(0), Cin, Sum(0), C1);
    FA1: full_adder PORT MAP (A(1), B(1), C1, Sum(1), C2);
    FA2: full_adder PORT MAP (A(2), B(2), C2, Sum(2), Cout);
END structural;
