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
-- Generated on "02/10/2025 11:55:37"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          week1
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY week1_vhd_vec_tst IS
END week1_vhd_vec_tst;
ARCHITECTURE week1_arch OF week1_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL a0 : STD_LOGIC;
SIGNAL a1 : STD_LOGIC;
SIGNAL b0 : STD_LOGIC;
SIGNAL b1 : STD_LOGIC;
SIGNAL carry : STD_LOGIC;
SIGNAL sum0 : STD_LOGIC;
SIGNAL sum1 : STD_LOGIC;
COMPONENT week1
	PORT (
	a0 : IN STD_LOGIC;
	a1 : IN STD_LOGIC;
	b0 : IN STD_LOGIC;
	b1 : IN STD_LOGIC;
	carry : BUFFER STD_LOGIC;
	sum0 : BUFFER STD_LOGIC;
	sum1 : BUFFER STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : week1
	PORT MAP (
-- list connections between master ports and signals
	a0 => a0,
	a1 => a1,
	b0 => b0,
	b1 => b1,
	carry => carry,
	sum0 => sum0,
	sum1 => sum1
	);

-- a0
t_prcs_a0: PROCESS
BEGIN
	a0 <= '0';
	WAIT FOR 20000 ps;
	a0 <= '1';
	WAIT FOR 20000 ps;
	a0 <= '0';
	WAIT FOR 60000 ps;
	a0 <= '1';
	WAIT FOR 20000 ps;
	a0 <= '0';
	WAIT FOR 20000 ps;
	a0 <= '1';
	WAIT FOR 20000 ps;
	a0 <= '0';
	WAIT FOR 40000 ps;
	a0 <= '1';
	WAIT FOR 20000 ps;
	a0 <= '0';
	WAIT FOR 280000 ps;
	a0 <= '1';
	WAIT FOR 20000 ps;
	a0 <= '0';
WAIT;
END PROCESS t_prcs_a0;

-- a1
t_prcs_a1: PROCESS
BEGIN
	a1 <= '0';
	WAIT FOR 40000 ps;
	a1 <= '1';
	WAIT FOR 20000 ps;
	a1 <= '0';
	WAIT FOR 40000 ps;
	a1 <= '1';
	WAIT FOR 20000 ps;
	a1 <= '0';
	WAIT FOR 20000 ps;
	a1 <= '1';
	WAIT FOR 20000 ps;
	a1 <= '0';
	WAIT FOR 40000 ps;
	a1 <= '1';
	WAIT FOR 20000 ps;
	a1 <= '0';
	WAIT FOR 140000 ps;
	a1 <= '1';
	WAIT FOR 40000 ps;
	a1 <= '0';
	WAIT FOR 40000 ps;
	a1 <= '1';
	WAIT FOR 20000 ps;
	a1 <= '0';
WAIT;
END PROCESS t_prcs_a1;

-- b0
t_prcs_b0: PROCESS
BEGIN
	b0 <= '0';
	WAIT FOR 60000 ps;
	b0 <= '1';
	WAIT FOR 20000 ps;
	b0 <= '0';
	WAIT FOR 60000 ps;
	b0 <= '1';
	WAIT FOR 20000 ps;
	b0 <= '0';
	WAIT FOR 40000 ps;
	b0 <= '1';
	WAIT FOR 20000 ps;
	b0 <= '0';
	WAIT FOR 60000 ps;
	b0 <= '1';
	WAIT FOR 20000 ps;
	b0 <= '0';
	WAIT FOR 60000 ps;
	b0 <= '1';
	WAIT FOR 40000 ps;
	b0 <= '0';
	WAIT FOR 40000 ps;
	b0 <= '1';
	WAIT FOR 20000 ps;
	b0 <= '0';
WAIT;
END PROCESS t_prcs_b0;

-- b1
t_prcs_b1: PROCESS
BEGIN
	b1 <= '0';
	WAIT FOR 80000 ps;
	b1 <= '1';
	WAIT FOR 20000 ps;
	b1 <= '0';
	WAIT FOR 100000 ps;
	b1 <= '1';
	WAIT FOR 20000 ps;
	b1 <= '0';
	WAIT FOR 60000 ps;
	b1 <= '1';
	WAIT FOR 20000 ps;
	b1 <= '0';
	WAIT FOR 60000 ps;
	b1 <= '1';
	WAIT FOR 40000 ps;
	b1 <= '0';
	WAIT FOR 100000 ps;
	b1 <= '1';
	WAIT FOR 20000 ps;
	b1 <= '0';
WAIT;
END PROCESS t_prcs_b1;
END week1_arch;
