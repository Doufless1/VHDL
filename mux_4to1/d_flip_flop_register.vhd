LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY d_flip_flop_register IS
    PORT (
        D       : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- 8-bit data input
        Clock   : IN STD_LOGIC;                    -- Clock signal
        Reset   : IN STD_LOGIC;                    -- Asynchronous reset
        Q       : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- 8-bit output
    );
END d_flip_flop_register;

ARCHITECTURE behavior OF d_flip_flop_register IS
BEGIN
    PROCESS (Clock, Reset)
    BEGIN
        -- Asynchronous reset
        IF Reset = '1' THEN
            Q <= "00000000";
        -- Negative edge triggered D flip-flop
        ELSIF (Clock'EVENT AND Clock = '0') THEN
            Q <= D;
        END IF;
    END PROCESS;
END behavior;

--On Reset (Reset = 1) → Q is cleared (00000000).
--On Clock falling edge (Clock'event AND Clock = '0') → D is latched into Q.

