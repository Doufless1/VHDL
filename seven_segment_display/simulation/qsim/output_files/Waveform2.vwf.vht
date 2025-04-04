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
-- Generated on "03/04/2025 13:26:23"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          top_module
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY top_module_vhd_vec_tst IS
END top_module_vhd_vec_tst;
ARCHITECTURE top_module_arch OF top_module_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL A : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL Display_Select : STD_LOGIC;
SIGNAL segment_a : STD_LOGIC;
SIGNAL segment_b : STD_LOGIC;
SIGNAL segment_c : STD_LOGIC;
SIGNAL segment_d : STD_LOGIC;
SIGNAL segment_e : STD_LOGIC;
SIGNAL segment_f : STD_LOGIC;
SIGNAL segment_g : STD_LOGIC;
COMPONENT top_module
	PORT (
	A : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	Display_Select : IN STD_LOGIC;
	segment_a : OUT STD_LOGIC;
	segment_b : OUT STD_LOGIC;
	segment_c : OUT STD_LOGIC;
	segment_d : OUT STD_LOGIC;
	segment_e : OUT STD_LOGIC;
	segment_f : OUT STD_LOGIC;
	segment_g : OUT STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : top_module
	PORT MAP (
-- list connections between master ports and signals
	A => A,
	Display_Select => Display_Select,
	segment_a => segment_a,
	segment_b => segment_b,
	segment_c => segment_c,
	segment_d => segment_d,
	segment_e => segment_e,
	segment_f => segment_f,
	segment_g => segment_g
	);
-- A[3]
t_prcs_A_3: PROCESS
BEGIN
	A(3) <= '0';
	WAIT FOR 300000 ps;
	A(3) <= '1';
	WAIT FOR 20000 ps;
	A(3) <= '0';
	WAIT FOR 20000 ps;
	A(3) <= '1';
	WAIT FOR 20000 ps;
	A(3) <= '0';
	WAIT FOR 40000 ps;
	A(3) <= '1';
	WAIT FOR 20000 ps;
	A(3) <= '0';
	WAIT FOR 40000 ps;
	A(3) <= '1';
	WAIT FOR 20000 ps;
	A(3) <= '0';
	WAIT FOR 20000 ps;
	A(3) <= '1';
	WAIT FOR 20000 ps;
	A(3) <= '0';
	WAIT FOR 20000 ps;
	A(3) <= '1';
	WAIT FOR 20000 ps;
	A(3) <= '0';
	WAIT FOR 20000 ps;
	A(3) <= '1';
	WAIT FOR 40000 ps;
	A(3) <= '0';
	WAIT FOR 20000 ps;
	A(3) <= '1';
	WAIT FOR 20000 ps;
	A(3) <= '0';
WAIT;
END PROCESS t_prcs_A_3;
-- A[2]
t_prcs_A_2: PROCESS
BEGIN
	A(2) <= '0';
	WAIT FOR 140000 ps;
	A(2) <= '1';
	WAIT FOR 20000 ps;
	A(2) <= '0';
	WAIT FOR 20000 ps;
	A(2) <= '1';
	WAIT FOR 20000 ps;
	A(2) <= '0';
	WAIT FOR 20000 ps;
	A(2) <= '1';
	WAIT FOR 20000 ps;
	A(2) <= '0';
	WAIT FOR 20000 ps;
	A(2) <= '1';
	WAIT FOR 20000 ps;
	A(2) <= '0';
	WAIT FOR 220000 ps;
	A(2) <= '1';
	WAIT FOR 20000 ps;
	A(2) <= '0';
	WAIT FOR 20000 ps;
	A(2) <= '1';
	WAIT FOR 20000 ps;
	A(2) <= '0';
	WAIT FOR 80000 ps;
	A(2) <= '1';
	WAIT FOR 20000 ps;
	A(2) <= '0';
WAIT;
END PROCESS t_prcs_A_2;
-- A[1]
t_prcs_A_1: PROCESS
BEGIN
	A(1) <= '0';
	WAIT FOR 60000 ps;
	A(1) <= '1';
	WAIT FOR 20000 ps;
	A(1) <= '0';
	WAIT FOR 20000 ps;
	A(1) <= '1';
	WAIT FOR 20000 ps;
	A(1) <= '0';
	WAIT FOR 100000 ps;
	A(1) <= '1';
	WAIT FOR 20000 ps;
	A(1) <= '0';
	WAIT FOR 20000 ps;
	A(1) <= '1';
	WAIT FOR 20000 ps;
	A(1) <= '0';
	WAIT FOR 120000 ps;
	A(1) <= '1';
	WAIT FOR 20000 ps;
	A(1) <= '0';
	WAIT FOR 40000 ps;
	A(1) <= '1';
	WAIT FOR 20000 ps;
	A(1) <= '0';
	WAIT FOR 100000 ps;
	A(1) <= '1';
	WAIT FOR 40000 ps;
	A(1) <= '0';
	WAIT FOR 20000 ps;
	A(1) <= '1';
	WAIT FOR 20000 ps;
	A(1) <= '0';
WAIT;
END PROCESS t_prcs_A_1;
-- A[0]
t_prcs_A_0: PROCESS
BEGIN
	A(0) <= '0';
	WAIT FOR 40000 ps;
	A(0) <= '1';
	WAIT FOR 20000 ps;
	A(0) <= '0';
	WAIT FOR 40000 ps;
	A(0) <= '1';
	WAIT FOR 20000 ps;
	A(0) <= '0';
	WAIT FOR 60000 ps;
	A(0) <= '1';
	WAIT FOR 20000 ps;
	A(0) <= '0';
	WAIT FOR 60000 ps;
	A(0) <= '1';
	WAIT FOR 20000 ps;
	A(0) <= '0';
	WAIT FOR 60000 ps;
	A(0) <= '1';
	WAIT FOR 20000 ps;
	A(0) <= '0';
	WAIT FOR 100000 ps;
	A(0) <= '1';
	WAIT FOR 20000 ps;
	A(0) <= '0';
	WAIT FOR 60000 ps;
	A(0) <= '1';
	WAIT FOR 20000 ps;
	A(0) <= '0';
	WAIT FOR 40000 ps;
	A(0) <= '1';
	WAIT FOR 20000 ps;
	A(0) <= '0';
	WAIT FOR 20000 ps;
	A(0) <= '1';
	WAIT FOR 20000 ps;
	A(0) <= '0';
WAIT;
END PROCESS t_prcs_A_0;

-- Display_Select
t_prcs_Display_Select: PROCESS
BEGIN
	Display_Select <= '0';
WAIT;
END PROCESS t_prcs_Display_Select;
END top_module_arch;
