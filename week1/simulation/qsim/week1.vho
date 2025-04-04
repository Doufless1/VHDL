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

-- VENDOR "Altera"
-- PROGRAM "Quartus Prime"
-- VERSION "Version 20.1.1 Build 720 11/11/2020 SJ Lite Edition"

-- DATE "02/10/2025 11:55:38"

-- 
-- Device: Altera 10M08SAE144C8GES Package EQFP144
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY FIFTYFIVENM;
LIBRARY IEEE;
USE FIFTYFIVENM.FIFTYFIVENM_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	week1 IS
    PORT (
	a0 : IN std_logic;
	a1 : IN std_logic;
	b0 : IN std_logic;
	b1 : IN std_logic;
	sum0 : BUFFER std_logic;
	sum1 : BUFFER std_logic;
	carry : BUFFER std_logic
	);
END week1;

ARCHITECTURE structure OF week1 IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_a0 : std_logic;
SIGNAL ww_a1 : std_logic;
SIGNAL ww_b0 : std_logic;
SIGNAL ww_b1 : std_logic;
SIGNAL ww_sum0 : std_logic;
SIGNAL ww_sum1 : std_logic;
SIGNAL ww_carry : std_logic;
SIGNAL \sum0~output_o\ : std_logic;
SIGNAL \sum1~output_o\ : std_logic;
SIGNAL \carry~output_o\ : std_logic;
SIGNAL \a0~input_o\ : std_logic;
SIGNAL \b0~input_o\ : std_logic;
SIGNAL \sum0~0_combout\ : std_logic;
SIGNAL \a1~input_o\ : std_logic;
SIGNAL \b1~input_o\ : std_logic;
SIGNAL \sum1~0_combout\ : std_logic;
SIGNAL \carry~0_combout\ : std_logic;

BEGIN

ww_a0 <= a0;
ww_a1 <= a1;
ww_b0 <= b0;
ww_b1 <= b1;
sum0 <= ww_sum0;
sum1 <= ww_sum1;
carry <= ww_carry;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

\sum0~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \sum0~0_combout\,
	devoe => ww_devoe,
	o => \sum0~output_o\);

\sum1~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \sum1~0_combout\,
	devoe => ww_devoe,
	o => \sum1~output_o\);

\carry~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \carry~0_combout\,
	devoe => ww_devoe,
	o => \carry~output_o\);

\a0~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_a0,
	o => \a0~input_o\);

\b0~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_b0,
	o => \b0~input_o\);

\sum0~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \sum0~0_combout\ = \a0~input_o\ $ (\b0~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111111110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \a0~input_o\,
	datad => \b0~input_o\,
	combout => \sum0~0_combout\);

\a1~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_a1,
	o => \a1~input_o\);

\b1~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_b1,
	o => \b1~input_o\);

\sum1~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \sum1~0_combout\ = \a1~input_o\ $ (\b1~input_o\ $ (((\a0~input_o\ & \b0~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000011101111000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \a0~input_o\,
	datab => \b0~input_o\,
	datac => \a1~input_o\,
	datad => \b1~input_o\,
	combout => \sum1~0_combout\);

\carry~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \carry~0_combout\ = (\b1~input_o\ & ((\a1~input_o\) # ((\b0~input_o\ & \a0~input_o\)))) # (!\b1~input_o\ & (\b0~input_o\ & (\a0~input_o\ & \a1~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100010000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \b0~input_o\,
	datab => \a0~input_o\,
	datac => \b1~input_o\,
	datad => \a1~input_o\,
	combout => \carry~0_combout\);

ww_sum0 <= \sum0~output_o\;

ww_sum1 <= \sum1~output_o\;

ww_carry <= \carry~output_o\;
END structure;


