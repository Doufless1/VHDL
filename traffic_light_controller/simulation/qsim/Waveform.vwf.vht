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
-- Generated on "03/31/2025 20:29:12"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          traffic_light_controller
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY traffic_light_controller_vhd_vec_tst IS
END traffic_light_controller_vhd_vec_tst;
ARCHITECTURE traffic_light_controller_arch OF traffic_light_controller_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL car_green : STD_LOGIC;
SIGNAL car_orange : STD_LOGIC;
SIGNAL car_red : STD_LOGIC;
SIGNAL clk : STD_LOGIC;
SIGNAL ped_green : STD_LOGIC;
SIGNAL ped_red : STD_LOGIC;
SIGNAL pedestrian_btn : STD_LOGIC;
SIGNAL reset : STD_LOGIC;
COMPONENT traffic_light_controller
	PORT (
	car_green : OUT STD_LOGIC;
	car_orange : OUT STD_LOGIC;
	car_red : OUT STD_LOGIC;
	clk : IN STD_LOGIC;
	ped_green : OUT STD_LOGIC;
	ped_red : OUT STD_LOGIC;
	pedestrian_btn : IN STD_LOGIC;
	reset : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : traffic_light_controller
	PORT MAP (
-- list connections between master ports and signals
	car_green => car_green,
	car_orange => car_orange,
	car_red => car_red,
	clk => clk,
	ped_green => ped_green,
	ped_red => ped_red,
	pedestrian_btn => pedestrian_btn,
	reset => reset
	);

-- clk
t_prcs_clk: PROCESS
BEGIN
	clk <= '0';
	WAIT FOR 15000 ps;
	clk <= '1';
	WAIT FOR 5000 ps;
	clk <= '0';
	WAIT FOR 35000 ps;
	clk <= '1';
	WAIT FOR 5000 ps;
	clk <= '0';
	WAIT FOR 35000 ps;
	clk <= '1';
	WAIT FOR 5000 ps;
	clk <= '0';
	WAIT FOR 35000 ps;
	clk <= '1';
	WAIT FOR 5000 ps;
	clk <= '0';
WAIT;
END PROCESS t_prcs_clk;

-- pedestrian_btn
t_prcs_pedestrian_btn: PROCESS
BEGIN
	pedestrian_btn <= '0';
	WAIT FOR 50000 ps;
	pedestrian_btn <= '1';
	WAIT FOR 10000 ps;
	pedestrian_btn <= '0';
	WAIT FOR 30000 ps;
	pedestrian_btn <= '1';
	WAIT FOR 10000 ps;
	pedestrian_btn <= '0';
WAIT;
END PROCESS t_prcs_pedestrian_btn;

-- reset
t_prcs_reset: PROCESS
BEGIN
	reset <= '1';
	WAIT FOR 10000 ps;
	reset <= '0';
WAIT;
END PROCESS t_prcs_reset;
END traffic_light_controller_arch;
