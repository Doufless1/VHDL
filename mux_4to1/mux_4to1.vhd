LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux_4to1 IS
    PORT (
        D0, D1, D2, D3 : IN STD_LOGIC;  -- 4 Data Inputs
        S : IN STD_LOGIC_VECTOR(1 DOWNTO 0); -- Select Signal
        Y : OUT STD_LOGIC  -- Output
    );
END mux_4to1;

ARCHITECTURE behavioral OF mux_4to1 IS
BEGIN
    PROCESS (S, D0, D1, D2, D3)
    BEGIN
        CASE S IS
            WHEN "00" => Y <= D0;
            WHEN "01" => Y <= D1;
            WHEN "10" => Y <= D2;
            WHEN "11" => Y <= D3;
            WHEN OTHERS => Y <= '0';
        END CASE;
    END PROCESS;
END behavioral;
