LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY top_module IS
    PORT (
        A : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        Display_Select : IN STD_LOGIC;
        segment_a, segment_b, segment_c, segment_d,
        segment_e, segment_f, segment_g : OUT STD_LOGIC
    );
END top_module;

ARCHITECTURE structural OF top_module IS
    COMPONENT even_parity_checker
        PORT (
            A : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            Parity_Out : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT seven_segment_display
        PORT (
            hex_digit : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            segment_a, segment_b, segment_c, segment_d,
            segment_e, segment_f, segment_g : OUT STD_LOGIC
        );
    END COMPONENT;

    -- ✅ FIXED: Change Parity_Result to STD_LOGIC (1-bit)
    SIGNAL Parity_Result : STD_LOGIC;  
    SIGNAL Selected_Input : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN
    -- Parity checker instance
    Parity_Checker: even_parity_checker PORT MAP (
        A => A,
        Parity_Out => Parity_Result -- ✅ FIXED: Direct connection, no index (0)
    );

    -- Select between A and Parity result
    Selected_Input <= A WHEN Display_Select = '0' ELSE ("000" & Parity_Result); -- ✅ FIXED: Use single bit

    -- 7-Segment Display Instance
    Display: seven_segment_display PORT MAP (
        hex_digit => Selected_Input,
        segment_a => segment_a, segment_b => segment_b, segment_c => segment_c,
        segment_d => segment_d, segment_e => segment_e, segment_f => segment_f, 
        segment_g => segment_g
    );

END structural;
