library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;

entity uart_receiver_tb is
end entity;

architecture Behavioral of uart_receiver_tb is
    component serial_text_transmitte
        Port (
            clk   : in  std_logic;
            reset : in  std_logic;
            tx    : out std_logic
        );
    end component;

    constant CLK_PERIOD : time := 20 ns; -- 50 MHz
    constant BAUD_RATE  : integer := 9600;
    constant BIT_TIME   : time := 104.167 us;  -- precise bit duration

    signal clk      : std_logic := '0';
    signal reset    : std_logic := '1';
    signal tx       : std_logic := '1';
    signal sim_done : boolean := false;

    -- Function to convert std_logic_vector to hex string (since to_hstring may not be available)
    function to_hex_string(slv: std_logic_vector) return string is
        constant hex_table: string(1 to 16) := "0123456789ABCDEF";
        variable result: string(1 to slv'length/4);
        variable temp: std_logic_vector(3 downto 0);
        variable nibble_pos: integer;
    begin
        for i in result'range loop
            nibble_pos := (i-1)*4;
            temp := slv(nibble_pos+3 downto nibble_pos);
            result(i) := hex_table(to_integer(unsigned(temp))+1);
        end loop;
        return result;
    end function;

begin

    -- Instantiate the DUT
    dut: serial_text_transmitte
        port map (
            clk   => clk,
            reset => reset,
            tx    => tx
        );

    -- Clock generation
    clk_process: process
    begin
        while not sim_done loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- UART Receiver process
    uart_receiver: process
        variable v_char : character;
        variable v_byte : std_logic_vector(7 downto 0);
        variable L : line;
    begin
        wait for 100 ns;
        reset <= '0';

        for i in 0 to 20 loop  -- receive up to 20 characters
            -- Wait for start bit
            wait until falling_edge(tx);
            wait for BIT_TIME/2;  -- Wait half bit time
            
            -- Verify we're still in start bit
            assert tx = '0' report "False start bit detected" severity warning;
            wait for BIT_TIME;  -- Now at middle of first data bit
            
            -- Collect 8 data bits - IMPORTANT: Reversing bit order for correct reception
            for bit_idx in 0 to 7 loop
                v_byte(bit_idx) := tx;  -- Store bits LSB first
                wait for BIT_TIME;
            end loop;

            -- Check for stop bit
            assert tx = '1' report "Invalid stop bit" severity warning;

            -- Print received character
            v_char := character'val(to_integer(unsigned(v_byte)));
            write(L, string'("Received: "));
            write(L, v_char);
            write(L, string'(" (Hex: 0x"));
            write(L, to_hex_string(v_byte));
            write(L, string'(")"));
            writeline(output, L);
        end loop;

        sim_done <= true;
        wait;
    end process;

end architecture;