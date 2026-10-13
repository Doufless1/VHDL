LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY two_to_four_decoder_tb IS
END two_to_four_decoder_tb;

ARCHITECTURE behavior OF two_to_four_decoder_tb IS
    COMPONENT two_to_four_decoder
        PORT (
            A : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            Y : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;
    
    -- Test signals
    SIGNAL A_tb : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL Y_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN
    -- Instantiate the decoder
    UUT: two_to_four_decoder PORT MAP (A => A_tb, Y => Y_tb);

    -- Test process
    PROCESS
    BEGIN
        -- Case 1: A = 00 → Y = 0001
        A_tb <= "00"; WAIT FOR 20 ns;
        
        -- Case 2: A = 01 → Y = 0010
        A_tb <= "01"; WAIT FOR 20 ns;
        
        -- Case 3: A = 10 → Y = 0100
        A_tb <= "10"; WAIT FOR 20 ns;
        
        -- Case 4: A = 11 → Y = 1000
        A_tb <= "11"; WAIT FOR 20 ns;
        
        -- End simulation
        WAIT;
    END PROCESS;
END behavior;
