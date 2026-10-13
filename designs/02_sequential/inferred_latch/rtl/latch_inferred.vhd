-- ilatch.vhd
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ilatch IS
    PORT(
        A, B          : IN STD_LOGIC;
        Output1, Output2 : OUT STD_LOGIC
    );
END ilatch;

ARCHITECTURE behavior OF ilatch IS
BEGIN
    PROCESS (A, B)
    BEGIN
        IF A = '0' THEN
            Output1 <= '0';
            Output2 <= '0';
        ELSE
            IF B = '1' THEN
                Output1 <= '1';
                Output2 <= '1';
            ELSE
                Output1 <= '0';
                Output2 <= 'Z';  -- shows latch behavior: not assigned => holds previous value
            END IF;
        END IF;
    END PROCESS;
END behavior;

--Time Clock REST Enable Up_Down Action
--0	ns	 0   1	  X	   X 	    Reset → 00000000
--40	ns	 RE  0	  1	   1	    Count up → 00000001
--80	ns	 RE  0	  1      1	    Count up → 00000010
--120ns	 RE  0	  1	   0	    Count down → 00000001
--160ns	 RE  0	  1	   0	    Count down → 00000000
--200ns	 RE  0	  0	   X	    Hold value
--240ns	 RE  1	  X	   X	    Reset again