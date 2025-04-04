LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY two_to_four_decoder IS
    PORT (
        A : IN STD_LOGIC_VECTOR(1 DOWNTO 0); -- 2-bit input
        Y : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) -- 4-bit output
    );
END two_to_four_decoder;

ARCHITECTURE behavior OF two_to_four_decoder IS
BEGIN
    PROCESS(A)
    BEGIN
        CASE A IS
            WHEN "00" => Y <= "0001"; -- Output Y0 active
            WHEN "01" => Y <= "0010"; -- Output Y1 active
            WHEN "10" => Y <= "0100"; -- Output Y2 active
            WHEN "11" => Y <= "1000"; -- Output Y3 active
            WHEN OTHERS => Y <= "0000"; -- Default case
        END CASE;
    END PROCESS;
END behavior;
