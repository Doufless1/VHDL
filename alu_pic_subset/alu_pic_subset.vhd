-- File: alu_pic_subset.vhd
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY alu_pic_subset IS
    PORT (
        op_code     : IN  STD_LOGIC_VECTOR(6 DOWNTO 0); -- 7 MSB op_code
        A_input      : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
        B_input      : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
        ALU_output   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END alu_pic_subset;

ARCHITECTURE behavior OF alu_pic_subset IS
BEGIN
    PROCESS (op_code, A_input, B_input)
    BEGIN
        CASE op_code IS
            WHEN "0000001" =>  -- ADDWF
                ALU_output <= A_input + B_input;

            WHEN "0000010" =>  -- ANDWF
                ALU_output <= A_input AND B_input;

            WHEN "0000011" =>  -- CLRF
                ALU_output <= (OTHERS => '0');

            WHEN "0000100" =>  -- INCF
                ALU_output <= B_input + 1;

            WHEN "0000101" =>  -- MOVF
                ALU_output <= B_input;

            WHEN "0000110" =>  -- BSF
                ALU_output <= B_input OR A_input; -- Set bit using mask

            WHEN OTHERS =>
                ALU_output <= (OTHERS => '0');
        END CASE;
    END PROCESS;
END behavior;
