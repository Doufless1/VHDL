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
-- Generated on "03/04/2025 13:00:40"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          seven_segment_display
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY seven_segment_display_vhd_vec_tst IS
END seven_segment_display_vhd_vec_tst;
ARCHITECTURE seven_segment_display_arch OF seven_segment_display_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL hex_digit : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL segment_a : STD_LOGIC;
SIGNAL segment_b : STD_LOGIC;
SIGNAL segment_c : STD_LOGIC;
SIGNAL segment_d : STD_LOGIC;
SIGNAL segment_e : STD_LOGIC;
SIGNAL segment_f : STD_LOGIC;
SIGNAL segment_g : STD_LOGIC;
COMPONENT seven_segment_display
	PORT (
	hex_digit : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	segment_a : BUFFER STD_LOGIC;
	segment_b : BUFFER STD_LOGIC;
	segment_c : BUFFER STD_LOGIC;
	segment_d : BUFFER STD_LOGIC;
	segment_e : BUFFER STD_LOGIC;
	segment_f : BUFFER STD_LOGIC;
	segment_g : BUFFER STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : seven_segment_display
	PORT MAP (
-- list connections between master ports and signals
	hex_digit => hex_digit,
	segment_a => segment_a,
	segment_b => segment_b,
	segment_c => segment_c,
	segment_d => segment_d,
	segment_e => segment_e,
	segment_f => segment_f,
	segment_g => segment_g
	);
-- hex_digit[3]
t_prcs_hex_digit_3: PROCESS
BEGIN
	hex_digit(3) <= '0';
	WAIT FOR 120000 ps;
	hex_digit(3) <= '1';
	WAIT FOR 10000 ps;
	hex_digit(3) <= '0';
	WAIT FOR 10000 ps;
	hex_digit(3) <= '1';
	WAIT FOR 10000 ps;
	hex_digit(3) <= '0';
WAIT;
END PROCESS t_prcs_hex_digit_3;
-- hex_digit[2]
t_prcs_hex_digit_2: PROCESS
BEGIN
	hex_digit(2) <= '0';
	WAIT FOR 40000 ps;
	hex_digit(2) <= '1';
	WAIT FOR 10000 ps;
	hex_digit(2) <= '0';
	WAIT FOR 10000 ps;
	hex_digit(2) <= '1';
	WAIT FOR 10000 ps;
	hex_digit(2) <= '0';
	WAIT FOR 10000 ps;
	hex_digit(2) <= '1';
	WAIT FOR 10000 ps;
	hex_digit(2) <= '0';
	WAIT FOR 10000 ps;
	hex_digit(2) <= '1';
	WAIT FOR 10000 ps;
	hex_digit(2) <= '0';
WAIT;
END PROCESS t_prcs_hex_digit_2;
-- hex_digit[1]
t_prcs_hex_digit_1: PROCESS
BEGIN
	hex_digit(1) <= '0';
	WAIT FOR 20000 ps;
	hex_digit(1) <= '1';
	WAIT FOR 20000 ps;
	hex_digit(1) <= '0';
	WAIT FOR 40000 ps;
	hex_digit(1) <= '1';
	WAIT FOR 10000 ps;
	hex_digit(1) <= '0';
	WAIT FOR 10000 ps;
	hex_digit(1) <= '1';
	WAIT FOR 10000 ps;
	hex_digit(1) <= '0';
WAIT;
END PROCESS t_prcs_hex_digit_1;
-- hex_digit[0]
t_prcs_hex_digit_0: PROCESS
BEGIN
	hex_digit(0) <= '0';
	WAIT FOR 10000 ps;
	hex_digit(0) <= '1';
	WAIT FOR 10000 ps;
	hex_digit(0) <= '0';
	WAIT FOR 10000 ps;
	hex_digit(0) <= '1';
	WAIT FOR 10000 ps;
	hex_digit(0) <= '0';
	WAIT FOR 20000 ps;
	hex_digit(0) <= '1';
	WAIT FOR 10000 ps;
	hex_digit(0) <= '0';
	WAIT FOR 30000 ps;
	hex_digit(0) <= '1';
	WAIT FOR 10000 ps;
	hex_digit(0) <= '0';
	WAIT FOR 30000 ps;
	hex_digit(0) <= '1';
	WAIT FOR 10000 ps;
	hex_digit(0) <= '0';
WAIT;
END PROCESS t_prcs_hex_digit_0;
END seven_segment_display_arch;
