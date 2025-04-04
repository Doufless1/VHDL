-- File: single_port_ram.vhd
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY single_port_ram IS
  PORT(
    data  : IN  std_logic_vector(7 DOWNTO 0);
    addr  : IN  natural range 0 TO 63;
    we    : IN  std_logic := '1';
    clk   : IN  std_logic;
    q     : OUT std_logic_vector(7 DOWNTO 0)
  );
END single_port_ram;

ARCHITECTURE rtl OF single_port_ram IS
  SUBTYPE word_t IS std_logic_vector(7 DOWNTO 0);
  TYPE memory_t IS ARRAY (63 DOWNTO 0) OF word_t;
  SIGNAL ram : memory_t := (OTHERS => (OTHERS => '0'));
  SIGNAL addr_reg : natural range 0 TO 63 := 0;
BEGIN
  PROCESS(clk)
  BEGIN
    IF rising_edge(clk) THEN
      IF we = '1' THEN
        ram(addr) <= data;
      END IF;
      addr_reg <= addr;
    END IF;
  END PROCESS;

  q <= ram(addr_reg);
END rtl;
