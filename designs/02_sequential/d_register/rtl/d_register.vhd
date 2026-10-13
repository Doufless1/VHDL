LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY d_flip_flop_8bit IS
    PORT (
        D      : IN  STD_LOGIC_VECTOR(5 DOWNTO 0); -- 8-bit Data Input
        Clock  : IN  STD_LOGIC;  -- Clock
        Reset  : IN  STD_LOGIC;  -- Asynchronous Reset
        Q      : OUT STD_LOGIC_VECTOR(5 DOWNTO 0) -- 8-bit Data Output
    );
END d_flip_flop_8bit;

ARCHITECTURE behavior OF d_flip_flop_8bit IS
BEGIN
    PROCESS (Clock, Reset)
    BEGIN
        IF Reset = '1' THEN
            Q <= (OTHERS => '0');  -- Reset all bits to 0
        ELSIF falling_edge(Clock) THEN  -- Falling Edge Triggered
            Q <= D;  -- Store Data
        END IF;
    END PROCESS;
END behavior;
