LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY even_parity_checker IS
    PORT (
        A : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        Parity_Out : OUT STD_LOGIC
    );
END even_parity_checker;

ARCHITECTURE behavior OF even_parity_checker IS
BEGIN
    Parity_Out <= A(0) XOR A(1) XOR A(2) XOR A(3); -- Correct Even Parity Calculation
END behavior;
