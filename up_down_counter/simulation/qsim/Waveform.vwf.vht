-- Copyright (C) 2020  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- *****************************************************************************
-- This file contains a Vhdl test bench with test vectors .The test vectors     
-- are exported from a vector file in the Quartus Waveform Editor and apply to  
-- the top level entity of the current Quartus project .The user can use this   
-- testbench to simulate his design using a third-party simulation tool .       
-- *****************************************************************************
-- Generated on "03/24/2025 12:27:02"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          up_down_counter
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY up_down_counter_vhd_vec_tst IS
END up_down_counter_vhd_vec_tst;
ARCHITECTURE up_down_counter_arch OF up_down_counter_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL Clock : STD_LOGIC;
SIGNAL Count : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL Enable : STD_LOGIC;
SIGNAL Reset : STD_LOGIC;
SIGNAL Up_Down : STD_LOGIC;
COMPONENT up_down_counter
	PORT (
	Clock : IN STD_LOGIC;
	Count : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	Enable : IN STD_LOGIC;
	Reset : IN STD_LOGIC;
	Up_Down : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : up_down_counter
	PORT MAP (
-- list connections between master ports and signals
	Clock => Clock,
	Count => Count,
	Enable => Enable,
	Reset => Reset,
	Up_Down => Up_Down
	);

-- Clock
t_prcs_Clock: PROCESS
BEGIN
	FOR i IN 1 TO 5
	LOOP
		Clock <= '0';
		WAIT FOR 20000 ps;
		Clock <= '1';
		WAIT FOR 20000 ps;
	END LOOP;
	Clock <= '0';
WAIT;
END PROCESS t_prcs_Clock;

-- Enable
t_prcs_Enable: PROCESS
BEGIN
	Enable <= '0';
	WAIT FOR 20000 ps;
	Enable <= '1';
	WAIT FOR 10000 ps;
	Enable <= '0';
	WAIT FOR 30000 ps;
	Enable <= '1';
	WAIT FOR 10000 ps;
	Enable <= '0';
	WAIT FOR 30000 ps;
	Enable <= '1';
	WAIT FOR 10000 ps;
	Enable <= '0';
	WAIT FOR 30000 ps;
	Enable <= '1';
	WAIT FOR 10000 ps;
	Enable <= '0';
	WAIT FOR 30000 ps;
	Enable <= 'X';
	WAIT FOR 10000 ps;
	Enable <= '0';
WAIT;
END PROCESS t_prcs_Enable;

-- Reset
t_prcs_Reset: PROCESS
BEGIN
	Reset <= '1';
	WAIT FOR 10000 ps;
	Reset <= '0';
	WAIT FOR 170000 ps;
	Reset <= '1';
	WAIT FOR 10000 ps;
	Reset <= '0';
WAIT;
END PROCESS t_prcs_Reset;

-- Up_Down
t_prcs_Up_Down: PROCESS
BEGIN
	Up_Down <= 'X';
	WAIT FOR 10000 ps;
	Up_Down <= '0';
	WAIT FOR 10000 ps;
	Up_Down <= '1';
	WAIT FOR 10000 ps;
	Up_Down <= '0';
	WAIT FOR 30000 ps;
	Up_Down <= '1';
	WAIT FOR 10000 ps;
	Up_Down <= '0';
	WAIT FOR 110000 ps;
	Up_Down <= 'X';
	WAIT FOR 10000 ps;
	Up_Down <= '0';
WAIT;
END PROCESS t_prcs_Up_Down;
END up_down_counter_arch;
