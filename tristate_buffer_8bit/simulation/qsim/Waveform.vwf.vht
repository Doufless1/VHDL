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
-- Generated on "03/19/2025 12:19:53"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          tristate_buffer_8bit
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY tristate_buffer_8bit_vhd_vec_tst IS
END tristate_buffer_8bit_vhd_vec_tst;
ARCHITECTURE tristate_buffer_8bit_arch OF tristate_buffer_8bit_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL A : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL Control : STD_LOGIC;
SIGNAL Tri_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
COMPONENT tristate_buffer_8bit
	PORT (
	A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	Control : IN STD_LOGIC;
	Tri_out : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;
BEGIN
	i1 : tristate_buffer_8bit
	PORT MAP (
-- list connections between master ports and signals
	A => A,
	Control => Control,
	Tri_out => Tri_out
	);
-- A[7]
t_prcs_A_7: PROCESS
BEGIN
	A(7) <= '0';
	WAIT FOR 80000 ps;
	A(7) <= '1';
	WAIT FOR 20000 ps;
	A(7) <= '0';
	WAIT FOR 40000 ps;
	A(7) <= '1';
	WAIT FOR 20000 ps;
	A(7) <= '0';
	WAIT FOR 100000 ps;
	A(7) <= '1';
	WAIT FOR 20000 ps;
	A(7) <= '0';
WAIT;
END PROCESS t_prcs_A_7;
-- A[6]
t_prcs_A_6: PROCESS
BEGIN
	A(6) <= '0';
	WAIT FOR 200000 ps;
	A(6) <= '1';
	WAIT FOR 20000 ps;
	A(6) <= '0';
	WAIT FOR 40000 ps;
	A(6) <= '1';
	WAIT FOR 20000 ps;
	A(6) <= '0';
WAIT;
END PROCESS t_prcs_A_6;
-- A[5]
t_prcs_A_5: PROCESS
BEGIN
	A(5) <= '0';
	WAIT FOR 80000 ps;
	A(5) <= '1';
	WAIT FOR 20000 ps;
	A(5) <= '0';
	WAIT FOR 40000 ps;
	A(5) <= '1';
	WAIT FOR 20000 ps;
	A(5) <= '0';
	WAIT FOR 100000 ps;
	A(5) <= '1';
	WAIT FOR 20000 ps;
	A(5) <= '0';
WAIT;
END PROCESS t_prcs_A_5;
-- A[4]
t_prcs_A_4: PROCESS
BEGIN
	A(4) <= '0';
	WAIT FOR 200000 ps;
	A(4) <= '1';
	WAIT FOR 20000 ps;
	A(4) <= '0';
	WAIT FOR 40000 ps;
	A(4) <= '1';
	WAIT FOR 20000 ps;
	A(4) <= '0';
WAIT;
END PROCESS t_prcs_A_4;
-- A[3]
t_prcs_A_3: PROCESS
BEGIN
	A(3) <= '0';
	WAIT FOR 80000 ps;
	A(3) <= '1';
	WAIT FOR 20000 ps;
	A(3) <= '0';
	WAIT FOR 40000 ps;
	A(3) <= '1';
	WAIT FOR 20000 ps;
	A(3) <= '0';
	WAIT FOR 100000 ps;
	A(3) <= '1';
	WAIT FOR 20000 ps;
	A(3) <= '0';
WAIT;
END PROCESS t_prcs_A_3;
-- A[2]
t_prcs_A_2: PROCESS
BEGIN
	A(2) <= '0';
	WAIT FOR 200000 ps;
	A(2) <= '1';
	WAIT FOR 20000 ps;
	A(2) <= '0';
	WAIT FOR 40000 ps;
	A(2) <= '1';
	WAIT FOR 20000 ps;
	A(2) <= '0';
WAIT;
END PROCESS t_prcs_A_2;
-- A[1]
t_prcs_A_1: PROCESS
BEGIN
	A(1) <= '0';
	WAIT FOR 80000 ps;
	A(1) <= '1';
	WAIT FOR 20000 ps;
	A(1) <= '0';
	WAIT FOR 40000 ps;
	A(1) <= '1';
	WAIT FOR 20000 ps;
	A(1) <= '0';
	WAIT FOR 100000 ps;
	A(1) <= '1';
	WAIT FOR 20000 ps;
	A(1) <= '0';
WAIT;
END PROCESS t_prcs_A_1;
-- A[0]
t_prcs_A_0: PROCESS
BEGIN
	A(0) <= '0';
	WAIT FOR 200000 ps;
	A(0) <= '1';
	WAIT FOR 20000 ps;
	A(0) <= '0';
	WAIT FOR 40000 ps;
	A(0) <= '1';
	WAIT FOR 20000 ps;
	A(0) <= '0';
WAIT;
END PROCESS t_prcs_A_0;

-- Control
t_prcs_Control: PROCESS
BEGIN
	Control <= '0';
	WAIT FOR 140000 ps;
	Control <= '1';
	WAIT FOR 20000 ps;
	Control <= '0';
	WAIT FOR 100000 ps;
	Control <= '1';
	WAIT FOR 20000 ps;
	Control <= '0';
	WAIT FOR 60000 ps;
	Control <= '1';
	WAIT FOR 20000 ps;
	Control <= '0';
WAIT;
END PROCESS t_prcs_Control;
-- Tri_out[7]
t_prcs_Tri_out_7: PROCESS
BEGIN
	Tri_out(7) <= 'Z';
WAIT;
END PROCESS t_prcs_Tri_out_7;
-- Tri_out[6]
t_prcs_Tri_out_6: PROCESS
BEGIN
	Tri_out(6) <= 'Z';
WAIT;
END PROCESS t_prcs_Tri_out_6;
-- Tri_out[5]
t_prcs_Tri_out_5: PROCESS
BEGIN
	Tri_out(5) <= 'Z';
WAIT;
END PROCESS t_prcs_Tri_out_5;
-- Tri_out[4]
t_prcs_Tri_out_4: PROCESS
BEGIN
	Tri_out(4) <= 'Z';
WAIT;
END PROCESS t_prcs_Tri_out_4;
-- Tri_out[3]
t_prcs_Tri_out_3: PROCESS
BEGIN
	Tri_out(3) <= 'Z';
WAIT;
END PROCESS t_prcs_Tri_out_3;
-- Tri_out[2]
t_prcs_Tri_out_2: PROCESS
BEGIN
	Tri_out(2) <= 'Z';
WAIT;
END PROCESS t_prcs_Tri_out_2;
-- Tri_out[1]
t_prcs_Tri_out_1: PROCESS
BEGIN
	Tri_out(1) <= 'Z';
WAIT;
END PROCESS t_prcs_Tri_out_1;
-- Tri_out[0]
t_prcs_Tri_out_0: PROCESS
BEGIN
	Tri_out(0) <= 'Z';
WAIT;
END PROCESS t_prcs_Tri_out_0;
END tristate_buffer_8bit_arch;
