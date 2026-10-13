library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity serial_text_transmitte is
    Port (
        clk         : in  std_logic;        -- System clock (assumed to be 50MHz)
        reset       : in  std_logic;        -- Active high reset
        tx          : out std_logic         -- Serial output line
    );
end serial_text_transmitte;

architecture Behavioral of serial_text_transmitte is
    -- Constants
    constant BAUD_RATE     : integer := 9600;
    constant CLK_FREQ      : integer := 50000000; -- 50 MHz
    constant BAUD_DIVIDER  : integer := CLK_FREQ / BAUD_RATE;
    
    -- Text to transmit repeatedly
    type ROM_TYPE is array (0 to 5) of std_logic_vector(7 downto 0);
    constant TEXT_ROM : ROM_TYPE := (
        X"48", -- H (ASCII: 72)
        X"45", -- E (ASCII: 69)
        X"4C", -- L (ASCII: 76)
        X"4C", -- L (ASCII: 76)
        X"4F", -- O (ASCII: 79)
        X"21"  -- ! (ASCII: 33)
    );
    constant ROM_SIZE : integer := 6;
    
    -- State machine states
    type state_type is (IDLE, START_BIT, DATA_BITS, STOP_BIT);
    signal state : state_type := IDLE;
    
    -- Counters and control signals
    signal baud_counter   : integer range 0 to BAUD_DIVIDER - 1 := 0;
    signal bit_counter    : integer range 0 to 7 := 0;
    signal char_index     : integer range 0 to ROM_SIZE - 1 := 0;
    signal tx_data        : std_logic_vector(7 downto 0) := (others => '0');
    signal baud_tick      : std_logic := '0';
    
begin
    -- Baud rate generator
    baud_generator: process(clk, reset)
    begin
        if reset = '1' then
            baud_counter <= 0;
            baud_tick <= '0';
        elsif rising_edge(clk) then
            if baud_counter = BAUD_DIVIDER - 1 then
                baud_counter <= 0;
                baud_tick <= '1';
            else
                baud_counter <= baud_counter + 1;
                baud_tick <= '0';
            end if;
        end if;
    end process;
    
    -- Main transmission state machine
    tx_process: process(clk, reset)
    begin
        if reset = '1' then
            state <= IDLE;
            bit_counter <= 0;
            char_index <= 0;
            tx <= '1';  -- Idle state is high
            tx_data <= (others => '0');
        elsif rising_edge(clk) then
            if baud_tick = '1' then
                case state is
                    when IDLE =>
                        -- Load next character and start transmission
                        tx_data <= TEXT_ROM(char_index);
                        tx <= '0';  -- Start bit
                        state <= DATA_BITS;
                        bit_counter <= 0;
                        
                    when START_BIT =>
                        -- This state is defined but not used in original code
                        -- Adding it for completeness
                        tx <= '0';  -- Start bit
                        state <= DATA_BITS;
                        bit_counter <= 0;
                        
                    when DATA_BITS =>
                        -- Transmit data bits (LSB first)
                        tx <= tx_data(bit_counter);
                        
                        if bit_counter = 7 then
                            state <= STOP_BIT;
                        else
                            bit_counter <= bit_counter + 1;
                        end if;
                        
                    when STOP_BIT =>
                        -- Send stop bit
                        tx <= '1';
                        
                        -- Move to next character
                        if char_index = ROM_SIZE - 1 then
                            char_index <= 0;
                        else
                            char_index <= char_index + 1;
                        end if;
                        
                        state <= IDLE;
                        
                    when others =>
                        state <= IDLE;
                        tx <= '1';
                end case;
            end if;
        end if;
    end process;

end Behavioral;