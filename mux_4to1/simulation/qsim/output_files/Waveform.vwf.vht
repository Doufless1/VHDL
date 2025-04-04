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
-- Generated on "03/06/2025 13:32:02"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          demux_1to4
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY demux_1to4_vhd_vec_tst IS
END demux_1to4_vhd_vec_tst;
ARCHITECTURE demux_1to4_arch OF demux_1to4_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL D : STD_LOGIC;
SIGNAL S : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL Y0 : STD_LOGIC;
SIGNAL Y1 : STD_LOGIC;
SIGNAL Y2 : STD_LOGIC;
SIGNAL Y3 : STD_LOGIC;
COMPONENT demux_1to4
	PORT (
	D : IN STD_LOGIC;
	S : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	Y0 : OUT STD_LOGIC;
	Y1 : OUT STD_LOGIC;
	Y2 : OUT STD_LOGIC;
	Y3 : OUT STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : demux_1to4
	PORT MAP (
-- list connections between master ports and signals
	D => D,
	S => S,
	Y0 => Y0,
	Y1 => Y1,
	Y2 => Y2,
	Y3 => Y3
	);

-- D
t_prcs_D: PROCESS
BEGIN
	D <= '0';
	WAIT FOR 40000 ps;
	D <= '1';
	WAIT FOR 20000 ps;
	D <= '0';
	WAIT FOR 20000 ps;
	D <= '1';
	WAIT FOR 20000 ps;
	D <= '0';
	WAIT FOR 40000 ps;
	D <= '1';
	WAIT FOR 20000 ps;
	D <= '0';
	WAIT FOR 40000 ps;
	D <= '1';
	WAIT FOR 20000 ps;
	D <= '0';
WAIT;
END PROCESS t_prcs_D;
-- S[1]
t_prcs_S_1: PROCESS
BEGIN
	S(1) <= '0';
	WAIT FOR 140000 ps;
	S(1) <= '1';
	WAIT FOR 20000 ps;
	S(1) <= '0';
	WAIT FOR 40000 ps;
	S(1) <= '1';
	WAIT FOR 20000 ps;
	S(1) <= '0';
	WAIT FOR 120000 ps;
	S(1) <= '1';
	WAIT FOR 20000 ps;
	S(1) <= '0';
	WAIT FOR 20000 ps;
	S(1) <= '1';
	WAIT FOR 20000 ps;
	S(1) <= '0';
WAIT;
END PROCESS t_prcs_S_1;
-- S[0]
t_prcs_S_0: PROCESS
BEGIN
	S(0) <= '0';
	WAIT FOR 80000 ps;
	S(0) <= '1';
	WAIT FOR 20000 ps;
	S(0) <= '0';
	WAIT FOR 100000 ps;
	S(0) <= '1';
	WAIT FOR 20000 ps;
	S(0) <= '0';
	WAIT FOR 80000 ps;
	S(0) <= '1';
	WAIT FOR 20000 ps;
	S(0) <= '0';
	WAIT FOR 20000 ps;
	S(0) <= '1';
	WAIT FOR 20000 ps;
	S(0) <= '0';
WAIT;
END PROCESS t_prcs_S_0;
END demux_1to4_arch;
