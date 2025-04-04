LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY three_bit_adder_tb IS
END three_bit_adder_tb;

ARCHITECTURE behavior OF three_bit_adder_tb IS
    -- Component declaration
    COMPONENT three_bit_adder
        PORT (
            A, B : IN std_logic_vector(2 DOWNTO 0);
            Cin  : IN std_logic;
            Sum  : OUT std_logic_vector(2 DOWNTO 0);
            Cout : OUT std_logic
        );
    END COMPONENT;
    
    -- Test signals
    SIGNAL A_tb, B_tb : std_logic_vector(2 DOWNTO 0);
    SIGNAL Cin_tb     : std_logic;
    SIGNAL Sum_tb     : std_logic_vector(2 DOWNTO 0);
    SIGNAL Cout_tb    : std_logic;

BEGIN
    -- Instantiate the three_bit_adder
    UUT: three_bit_adder PORT MAP (
        A    => A_tb,
        B    => B_tb,
        Cin  => Cin_tb,
        Sum  => Sum_tb,
        Cout => Cout_tb
    );

    -- Test process
    PROCESS
    BEGIN
        -- Case 1: A = 000, B = 000, Cin = 0 (Sum = 000, Cout = 0)
        A_tb  <= "000"; B_tb  <= "000"; Cin_tb  <= '0';
        WAIT FOR 20 ns;

        -- Case 2: A = 001, B = 001, Cin = 0 (Sum = 010, Cout = 0)
        A_tb  <= "001"; B_tb  <= "001"; Cin_tb  <= '0';
        WAIT FOR 20 ns;

        -- Case 3: A = 011, B = 101, Cin = 1 (Sum = 001, Cout = 1)
        A_tb  <= "011"; B_tb  <= "101"; Cin_tb  <= '1';
        WAIT FOR 20 ns;

        -- Case 4: A = 111, B = 111, Cin = 1 (Sum = 111, Cout = 1)
        A_tb  <= "111"; B_tb  <= "111"; Cin_tb  <= '1';
        WAIT FOR 20 ns;

        -- End simulation
        WAIT;
    END PROCESS;
END behavior;
