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
-- Generated on "03/10/2025 13:11:49"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          d_flip_flop_8bit
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY d_flip_flop_8bit_vhd_vec_tst IS
END d_flip_flop_8bit_vhd_vec_tst;
ARCHITECTURE d_flip_flop_8bit_arch OF d_flip_flop_8bit_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL Clock : STD_LOGIC;
SIGNAL D : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL Q : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL Reset : STD_LOGIC;
COMPONENT d_flip_flop_8bit
	PORT (
	Clock : IN STD_LOGIC;
	D : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	Q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	Reset : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : d_flip_flop_8bit
	PORT MAP (
-- list connections between master ports and signals
	Clock => Clock,
	D => D,
	Q => Q,
	Reset => Reset
	);

-- Clock
t_prcs_Clock: PROCESS
BEGIN
	Clock <= '0';
	WAIT FOR 10000 ps;
	Clock <= '1';
	WAIT FOR 10000 ps;
	Clock <= '0';
	WAIT FOR 97500 ps;
	Clock <= '1';
	WAIT FOR 2500 ps;
	Clock <= '0';
	WAIT FOR 50000 ps;
	Clock <= '1';
	WAIT FOR 10000 ps;
	Clock <= '0';
	WAIT FOR 50000 ps;
	Clock <= '1';
	WAIT FOR 10000 ps;
	Clock <= '0';
	WAIT FOR 50000 ps;
	Clock <= '1';
	WAIT FOR 10000 ps;
	Clock <= '0';
WAIT;
END PROCESS t_prcs_Clock;
-- D[7]
t_prcs_D_7: PROCESS
BEGIN
	D(7) <= '0';
	WAIT FOR 40000 ps;
	D(7) <= '1';
	WAIT FOR 20000 ps;
	D(7) <= '0';
	WAIT FOR 40000 ps;
	D(7) <= '1';
	WAIT FOR 20000 ps;
	D(7) <= '0';
	WAIT FOR 40000 ps;
	D(7) <= '1';
	WAIT FOR 20000 ps;
	D(7) <= '0';
	WAIT FOR 40000 ps;
	D(7) <= '1';
	WAIT FOR 20000 ps;
	D(7) <= '0';
WAIT;
END PROCESS t_prcs_D_7;
-- D[6]
t_prcs_D_6: PROCESS
BEGIN
	D(6) <= '0';
	WAIT FOR 160000 ps;
	D(6) <= '1';
	WAIT FOR 20000 ps;
	D(6) <= '0';
	WAIT FOR 40000 ps;
	D(6) <= '1';
	WAIT FOR 20000 ps;
	D(6) <= '0';
	WAIT FOR 40000 ps;
	D(6) <= '1';
	WAIT FOR 20000 ps;
	D(6) <= '0';
WAIT;
END PROCESS t_prcs_D_6;
-- D[5]
t_prcs_D_5: PROCESS
BEGIN
	D(5) <= '0';
	WAIT FOR 40000 ps;
	D(5) <= '1';
	WAIT FOR 20000 ps;
	D(5) <= '0';
	WAIT FOR 40000 ps;
	D(5) <= '1';
	WAIT FOR 20000 ps;
	D(5) <= '0';
	WAIT FOR 100000 ps;
	D(5) <= '1';
	WAIT FOR 20000 ps;
	D(5) <= '0';
WAIT;
END PROCESS t_prcs_D_5;
-- D[4]
t_prcs_D_4: PROCESS
BEGIN
	D(4) <= '0';
	WAIT FOR 220000 ps;
	D(4) <= '1';
	WAIT FOR 20000 ps;
	D(4) <= '0';
	WAIT FOR 40000 ps;
	D(4) <= '1';
	WAIT FOR 20000 ps;
	D(4) <= '0';
WAIT;
END PROCESS t_prcs_D_4;
-- D[3]
t_prcs_D_3: PROCESS
BEGIN
	D(3) <= '0';
	WAIT FOR 100000 ps;
	D(3) <= '1';
	WAIT FOR 20000 ps;
	D(3) <= '0';
	WAIT FOR 40000 ps;
	D(3) <= '1';
	WAIT FOR 20000 ps;
	D(3) <= '0';
WAIT;
END PROCESS t_prcs_D_3;
-- D[2]
t_prcs_D_2: PROCESS
BEGIN
	D(2) <= '0';
	WAIT FOR 160000 ps;
	D(2) <= '1';
	WAIT FOR 20000 ps;
	D(2) <= '0';
	WAIT FOR 100000 ps;
	D(2) <= '1';
	WAIT FOR 20000 ps;
	D(2) <= '0';
WAIT;
END PROCESS t_prcs_D_2;
-- D[1]
t_prcs_D_1: PROCESS
BEGIN
	D(1) <= '0';
	WAIT FOR 40000 ps;
	D(1) <= '1';
	WAIT FOR 20000 ps;
	D(1) <= '0';
	WAIT FOR 40000 ps;
	D(1) <= '1';
	WAIT FOR 20000 ps;
	D(1) <= '0';
WAIT;
END PROCESS t_prcs_D_1;
-- D[0]
t_prcs_D_0: PROCESS
BEGIN
	D(0) <= '0';
	WAIT FOR 280000 ps;
	D(0) <= '1';
	WAIT FOR 20000 ps;
	D(0) <= '0';
WAIT;
END PROCESS t_prcs_D_0;

-- Reset
t_prcs_Reset: PROCESS
BEGIN
	Reset <= '0';
	WAIT FOR 10000 ps;
	Reset <= '1';
	WAIT FOR 10000 ps;
	Reset <= '0';
	WAIT FOR 20000 ps;
	Reset <= '1';
	WAIT FOR 20000 ps;
	Reset <= '0';
	WAIT FOR 200000 ps;
	Reset <= '1';
	WAIT FOR 20000 ps;
	Reset <= '0';
WAIT;
END PROCESS t_prcs_Reset;
END d_flip_flop_8bit_arch;
