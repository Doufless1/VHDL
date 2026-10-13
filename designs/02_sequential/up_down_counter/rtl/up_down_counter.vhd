-- File: up_down_counter.vhd
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY up_down_counter IS
    PORT (
        Clock      : IN  STD_LOGIC;
        Reset      : IN  STD_LOGIC;
        Enable     : IN  STD_LOGIC;
        Up_Down    : IN  STD_LOGIC;  -- '1' for up, '0' for down
        Count      : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END up_down_counter;

ARCHITECTURE behavior OF up_down_counter IS
    SIGNAL internal_count : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
    Count <= internal_count;

    PROCESS (Clock, Reset)
    BEGIN
        IF Reset = '1' THEN
            internal_count <= (OTHERS => '0');
        ELSIF Rising_Edge(Clock) THEN
            IF Enable = '1' THEN
                IF Up_Down = '1' THEN
                    internal_count <= internal_count + 1;
                ELSE
                    internal_count <= internal_count - 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;
END behavior;
