library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity serial_text_transmitter_tb is
end serial_text_transmitter_tb;

architecture Behavioral of serial_text_transmitter_tb is
    -- Component declaration
    component serial_text_transmitte
        Port (
            clk   : in  std_logic;
            reset : in  std_logic;
            tx    : out std_logic
        );
    end component;
    
    constant CLK_PERIOD : time := 20 ns;  -- 50 MHz
    
    signal clk      : std_logic := '0';
    signal reset    : std_logic := '1';
    signal tx       : std_logic;
    signal sim_done : boolean := false;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: serial_text_transmitte
        port map (
            clk   => clk,
            reset => reset,
            tx    => tx
        );

    -- Clock process
    clock_process: process
    begin
        while not sim_done loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Hold reset active
        reset <= '1';
        wait for 100 ns;

        -- Release reset
        reset <= '0';

        -- Let the transmitter send a few characters
        wait for 100 ms;

        -- Stop simulation
        sim_done <= true;
        wait;
    end process;

end Behavioral;
