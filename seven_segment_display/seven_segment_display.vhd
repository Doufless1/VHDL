LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY seven_segment_display IS
    PORT(
        hex_digit : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        segment_a, segment_b, segment_c, segment_d,
        segment_e, segment_f, segment_g : OUT std_logic
    );
END seven_segment_display;

ARCHITECTURE behavior OF seven_segment_display IS
    SIGNAL segment_data : STD_LOGIC_VECTOR(6 DOWNTO 0);
BEGIN
    PROCESS (hex_digit)
    BEGIN
        CASE hex_digit IS
            WHEN "0000" => segment_data <= "1111110";
            WHEN "0001" => segment_data <= "0110000";
            WHEN "0010" => segment_data <= "1101101";
            WHEN "0011" => segment_data <= "1111001";
            WHEN "0100" => segment_data <= "0110011";
            WHEN "0101" => segment_data <= "1011011";
            WHEN "0110" => segment_data <= "1011111";
            WHEN "0111" => segment_data <= "1110000";
            WHEN "1000" => segment_data <= "1111111";
            WHEN "1001" => segment_data <= "1111011";
            WHEN "1010" => segment_data <= "1110111";
            WHEN "1011" => segment_data <= "0011111";
            WHEN "1100" => segment_data <= "1001110";
            WHEN "1101" => segment_data <= "0111101";
            WHEN "1110" => segment_data <= "1001111";
            WHEN "1111" => segment_data <= "1000111";
            WHEN OTHERS => segment_data <= "0000000";
        END CASE;
    END PROCESS;
    
    segment_a <= NOT segment_data(6);
    segment_b <= NOT segment_data(5);
    segment_c <= NOT segment_data(4);
    segment_d <= NOT segment_data(3);
    segment_e <= NOT segment_data(2);
    segment_f <= NOT segment_data(1);
    segment_g <= NOT segment_data(0);
END behavior;


