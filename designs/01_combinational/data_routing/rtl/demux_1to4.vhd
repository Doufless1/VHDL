LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY demux_1to4 IS
    PORT (
        D : IN STD_LOGIC;  -- Single Data Input
        S : IN STD_LOGIC_VECTOR(1 DOWNTO 0); -- Select Signal
        Y0, Y1, Y2, Y3 : OUT STD_LOGIC -- Outputs
    );
END demux_1to4;

ARCHITECTURE structural OF demux_1to4 IS
BEGIN
    Y0 <= D WHEN S = "00" ELSE '0';
    Y1 <= D WHEN S = "01" ELSE '0';
    Y2 <= D WHEN S = "10" ELSE '0';
    Y3 <= D WHEN S = "11" ELSE '0';
END structural;
