library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tristate_buffer_8bit is
    Port ( A : in STD_LOGIC_VECTOR (7 downto 0);
           Control : in STD_LOGIC;
           Tri_out : inout STD_LOGIC_VECTOR (7 downto 0));
end tristate_buffer_8bit;

architecture Behavioral of tristate_buffer_8bit is
begin
    Tri_out <= A when Control = '0' else (others => 'Z');
end Behavioral;
