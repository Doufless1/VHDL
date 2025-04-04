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

-- DATE "03/31/2025 21:03:16"

-- 
-- Device: Altera 10M08DAF256C7G Package FBGA256
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY FIFTYFIVENM;
LIBRARY IEEE;
USE FIFTYFIVENM.FIFTYFIVENM_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	hard_block IS
    PORT (
	devoe : IN std_logic;
	devclrn : IN std_logic;
	devpor : IN std_logic
	);
END hard_block;

-- Design Ports Information
-- ~ALTERA_TMS~	=>  Location: PIN_H2,	 I/O Standard: 2.5 V Schmitt Trigger,	 Current Strength: Default
-- ~ALTERA_TCK~	=>  Location: PIN_H3,	 I/O Standard: 2.5 V Schmitt Trigger,	 Current Strength: Default
-- ~ALTERA_TDI~	=>  Location: PIN_G1,	 I/O Standard: 2.5 V Schmitt Trigger,	 Current Strength: Default
-- ~ALTERA_TDO~	=>  Location: PIN_H1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_CONFIG_SEL~	=>  Location: PIN_F8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_nCONFIG~	=>  Location: PIN_E8,	 I/O Standard: 2.5 V Schmitt Trigger,	 Current Strength: Default
-- ~ALTERA_nSTATUS~	=>  Location: PIN_F7,	 I/O Standard: 2.5 V Schmitt Trigger,	 Current Strength: Default
-- ~ALTERA_CONF_DONE~	=>  Location: PIN_E7,	 I/O Standard: 2.5 V Schmitt Trigger,	 Current Strength: Default


ARCHITECTURE structure OF hard_block IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL \~ALTERA_TMS~~padout\ : std_logic;
SIGNAL \~ALTERA_TCK~~padout\ : std_logic;
SIGNAL \~ALTERA_TDI~~padout\ : std_logic;
SIGNAL \~ALTERA_CONFIG_SEL~~padout\ : std_logic;
SIGNAL \~ALTERA_nCONFIG~~padout\ : std_logic;
SIGNAL \~ALTERA_nSTATUS~~padout\ : std_logic;
SIGNAL \~ALTERA_CONF_DONE~~padout\ : std_logic;
SIGNAL \~ALTERA_TMS~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_TCK~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_TDI~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_CONFIG_SEL~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_nCONFIG~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_nSTATUS~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_CONF_DONE~~ibuf_o\ : std_logic;

BEGIN

ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
END structure;


LIBRARY FIFTYFIVENM;
LIBRARY IEEE;
USE FIFTYFIVENM.FIFTYFIVENM_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	alu_pic_subset IS
    PORT (
	op_code : IN std_logic_vector(6 DOWNTO 0);
	A_input : IN std_logic_vector(7 DOWNTO 0);
	B_input : IN std_logic_vector(7 DOWNTO 0);
	ALU_output : OUT std_logic_vector(7 DOWNTO 0)
	);
END alu_pic_subset;

-- Design Ports Information
-- ALU_output[0]	=>  Location: PIN_M8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ALU_output[1]	=>  Location: PIN_R7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ALU_output[2]	=>  Location: PIN_M7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ALU_output[3]	=>  Location: PIN_P8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ALU_output[4]	=>  Location: PIN_R12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ALU_output[5]	=>  Location: PIN_P9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ALU_output[6]	=>  Location: PIN_T9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ALU_output[7]	=>  Location: PIN_R9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B_input[0]	=>  Location: PIN_J1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A_input[0]	=>  Location: PIN_M9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- op_code[2]	=>  Location: PIN_C5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- op_code[0]	=>  Location: PIN_L16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- op_code[1]	=>  Location: PIN_H6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- op_code[3]	=>  Location: PIN_B1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- op_code[4]	=>  Location: PIN_R10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- op_code[5]	=>  Location: PIN_P11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- op_code[6]	=>  Location: PIN_P10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B_input[1]	=>  Location: PIN_A6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A_input[1]	=>  Location: PIN_M10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B_input[2]	=>  Location: PIN_F9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A_input[2]	=>  Location: PIN_R5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B_input[3]	=>  Location: PIN_A7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A_input[3]	=>  Location: PIN_T8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B_input[4]	=>  Location: PIN_P6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A_input[4]	=>  Location: PIN_R11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B_input[5]	=>  Location: PIN_T11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A_input[5]	=>  Location: PIN_G6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B_input[6]	=>  Location: PIN_D12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A_input[6]	=>  Location: PIN_C6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B_input[7]	=>  Location: PIN_B5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A_input[7]	=>  Location: PIN_R8,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF alu_pic_subset IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_op_code : std_logic_vector(6 DOWNTO 0);
SIGNAL ww_A_input : std_logic_vector(7 DOWNTO 0);
SIGNAL ww_B_input : std_logic_vector(7 DOWNTO 0);
SIGNAL ww_ALU_output : std_logic_vector(7 DOWNTO 0);
SIGNAL \~QUARTUS_CREATED_ADC1~_CHSEL_bus\ : std_logic_vector(4 DOWNTO 0);
SIGNAL \~QUARTUS_CREATED_GND~I_combout\ : std_logic;
SIGNAL \~QUARTUS_CREATED_UNVM~~busy\ : std_logic;
SIGNAL \~QUARTUS_CREATED_ADC1~~eoc\ : std_logic;
SIGNAL \ALU_output[0]~output_o\ : std_logic;
SIGNAL \ALU_output[1]~output_o\ : std_logic;
SIGNAL \ALU_output[2]~output_o\ : std_logic;
SIGNAL \ALU_output[3]~output_o\ : std_logic;
SIGNAL \ALU_output[4]~output_o\ : std_logic;
SIGNAL \ALU_output[5]~output_o\ : std_logic;
SIGNAL \ALU_output[6]~output_o\ : std_logic;
SIGNAL \ALU_output[7]~output_o\ : std_logic;
SIGNAL \op_code[5]~input_o\ : std_logic;
SIGNAL \B_input[0]~input_o\ : std_logic;
SIGNAL \A_input[0]~input_o\ : std_logic;
SIGNAL \op_code[1]~input_o\ : std_logic;
SIGNAL \op_code[2]~input_o\ : std_logic;
SIGNAL \op_code[0]~input_o\ : std_logic;
SIGNAL \Mux7~0_combout\ : std_logic;
SIGNAL \Mux7~1_combout\ : std_logic;
SIGNAL \Add0~0_combout\ : std_logic;
SIGNAL \Add0~1_combout\ : std_logic;
SIGNAL \Mux7~2_combout\ : std_logic;
SIGNAL \Mux7~3_combout\ : std_logic;
SIGNAL \op_code[4]~input_o\ : std_logic;
SIGNAL \op_code[3]~input_o\ : std_logic;
SIGNAL \Mux7~4_combout\ : std_logic;
SIGNAL \op_code[6]~input_o\ : std_logic;
SIGNAL \Mux7~5_combout\ : std_logic;
SIGNAL \A_input[1]~input_o\ : std_logic;
SIGNAL \B_input[1]~input_o\ : std_logic;
SIGNAL \Add0~3_combout\ : std_logic;
SIGNAL \Add0~2\ : std_logic;
SIGNAL \Add0~4_combout\ : std_logic;
SIGNAL \Mux6~0_combout\ : std_logic;
SIGNAL \Mux6~1_combout\ : std_logic;
SIGNAL \Mux6~2_combout\ : std_logic;
SIGNAL \A_input[2]~input_o\ : std_logic;
SIGNAL \B_input[2]~input_o\ : std_logic;
SIGNAL \Add0~6_combout\ : std_logic;
SIGNAL \Add0~5\ : std_logic;
SIGNAL \Add0~7_combout\ : std_logic;
SIGNAL \Mux5~0_combout\ : std_logic;
SIGNAL \Mux5~1_combout\ : std_logic;
SIGNAL \Mux5~2_combout\ : std_logic;
SIGNAL \A_input[3]~input_o\ : std_logic;
SIGNAL \B_input[3]~input_o\ : std_logic;
SIGNAL \Add0~9_combout\ : std_logic;
SIGNAL \Add0~8\ : std_logic;
SIGNAL \Add0~10_combout\ : std_logic;
SIGNAL \Mux4~0_combout\ : std_logic;
SIGNAL \Mux4~1_combout\ : std_logic;
SIGNAL \Mux4~2_combout\ : std_logic;
SIGNAL \B_input[4]~input_o\ : std_logic;
SIGNAL \A_input[4]~input_o\ : std_logic;
SIGNAL \Add0~12_combout\ : std_logic;
SIGNAL \Add0~11\ : std_logic;
SIGNAL \Add0~13_combout\ : std_logic;
SIGNAL \Mux3~0_combout\ : std_logic;
SIGNAL \Mux3~1_combout\ : std_logic;
SIGNAL \Mux3~2_combout\ : std_logic;
SIGNAL \B_input[5]~input_o\ : std_logic;
SIGNAL \A_input[5]~input_o\ : std_logic;
SIGNAL \Add0~15_combout\ : std_logic;
SIGNAL \Add0~14\ : std_logic;
SIGNAL \Add0~16_combout\ : std_logic;
SIGNAL \Mux2~0_combout\ : std_logic;
SIGNAL \Mux2~1_combout\ : std_logic;
SIGNAL \Mux2~2_combout\ : std_logic;
SIGNAL \A_input[6]~input_o\ : std_logic;
SIGNAL \B_input[6]~input_o\ : std_logic;
SIGNAL \Add0~18_combout\ : std_logic;
SIGNAL \Add0~17\ : std_logic;
SIGNAL \Add0~19_combout\ : std_logic;
SIGNAL \Mux1~0_combout\ : std_logic;
SIGNAL \Mux1~1_combout\ : std_logic;
SIGNAL \Mux1~2_combout\ : std_logic;
SIGNAL \B_input[7]~input_o\ : std_logic;
SIGNAL \A_input[7]~input_o\ : std_logic;
SIGNAL \Add0~21_combout\ : std_logic;
SIGNAL \Add0~20\ : std_logic;
SIGNAL \Add0~22_combout\ : std_logic;
SIGNAL \Mux0~0_combout\ : std_logic;
SIGNAL \Mux0~1_combout\ : std_logic;
SIGNAL \Mux0~2_combout\ : std_logic;

COMPONENT hard_block
    PORT (
	devoe : IN std_logic;
	devclrn : IN std_logic;
	devpor : IN std_logic);
END COMPONENT;

BEGIN

ww_op_code <= op_code;
ww_A_input <= A_input;
ww_B_input <= B_input;
ALU_output <= ww_ALU_output;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

\~QUARTUS_CREATED_ADC1~_CHSEL_bus\ <= (\~QUARTUS_CREATED_GND~I_combout\ & \~QUARTUS_CREATED_GND~I_combout\ & \~QUARTUS_CREATED_GND~I_combout\ & \~QUARTUS_CREATED_GND~I_combout\ & \~QUARTUS_CREATED_GND~I_combout\);
auto_generated_inst : hard_block
PORT MAP (
	devoe => ww_devoe,
	devclrn => ww_devclrn,
	devpor => ww_devpor);

-- Location: LCCOMB_X11_Y12_N16
\~QUARTUS_CREATED_GND~I\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \~QUARTUS_CREATED_GND~I_combout\ = GND

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	combout => \~QUARTUS_CREATED_GND~I_combout\);

-- Location: IOOBUF_X17_Y0_N30
\ALU_output[0]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \Mux7~5_combout\,
	devoe => ww_devoe,
	o => \ALU_output[0]~output_o\);

-- Location: IOOBUF_X13_Y0_N16
\ALU_output[1]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \Mux6~2_combout\,
	devoe => ww_devoe,
	o => \ALU_output[1]~output_o\);

-- Location: IOOBUF_X11_Y0_N9
\ALU_output[2]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \Mux5~2_combout\,
	devoe => ww_devoe,
	o => \ALU_output[2]~output_o\);

-- Location: IOOBUF_X15_Y0_N16
\ALU_output[3]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \Mux4~2_combout\,
	devoe => ww_devoe,
	o => \ALU_output[3]~output_o\);

-- Location: IOOBUF_X19_Y0_N16
\ALU_output[4]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \Mux3~2_combout\,
	devoe => ww_devoe,
	o => \ALU_output[4]~output_o\);

-- Location: IOOBUF_X15_Y0_N23
\ALU_output[5]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \Mux2~2_combout\,
	devoe => ww_devoe,
	o => \ALU_output[5]~output_o\);

-- Location: IOOBUF_X13_Y0_N2
\ALU_output[6]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \Mux1~2_combout\,
	devoe => ww_devoe,
	o => \ALU_output[6]~output_o\);

-- Location: IOOBUF_X15_Y0_N30
\ALU_output[7]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \Mux0~2_combout\,
	devoe => ww_devoe,
	o => \ALU_output[7]~output_o\);

-- Location: IOIBUF_X19_Y0_N1
\op_code[5]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_op_code(5),
	o => \op_code[5]~input_o\);

-- Location: IOIBUF_X10_Y17_N1
\B_input[0]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B_input(0),
	o => \B_input[0]~input_o\);

-- Location: IOIBUF_X17_Y0_N22
\A_input[0]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A_input(0),
	o => \A_input[0]~input_o\);

-- Location: IOIBUF_X10_Y15_N22
\op_code[1]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_op_code(1),
	o => \op_code[1]~input_o\);

-- Location: IOIBUF_X6_Y10_N29
\op_code[2]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_op_code(2),
	o => \op_code[2]~input_o\);

-- Location: IOIBUF_X31_Y6_N1
\op_code[0]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_op_code(0),
	o => \op_code[0]~input_o\);

-- Location: LCCOMB_X16_Y8_N8
\Mux7~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Mux7~0_combout\ = (!\op_code[1]~input_o\ & ((\op_code[2]~input_o\) # (\op_code[0]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \op_code[2]~input_o\,
	datac => \op_code[1]~input_o\,
	datad => \op_code[0]~input_o\,
	combout => \Mux7~0_combout\);

-- Location: LCCOMB_X16_Y8_N26
\Mux7~1\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Mux7~1_combout\ = \op_code[2]~input_o\ $ (((!\op_code[1]~input_o\ & \op_code[0]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001111001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \op_code[2]~input_o\,
	datac => \op_code[1]~input_o\,
	datad => \op_code[0]~input_o\,
	combout => \Mux7~1_combout\);

-- Location: LCCOMB_X17_Y8_N8
\Add0~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Add0~0_combout\ = (\op_code[2]~input_o\) # (\A_input[0]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111110101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \op_code[2]~input_o\,
	datad => \A_input[0]~input_o\,
	combout => \Add0~0_combout\);

-- Location: LCCOMB_X17_Y8_N12
\Add0~1\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Add0~1_combout\ = (\B_input[0]~input_o\ & (\Add0~0_combout\ $ (VCC))) # (!\B_input[0]~input_o\ & (\Add0~0_combout\ & VCC))
-- \Add0~2\ = CARRY((\B_input[0]~input_o\ & \Add0~0_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110011010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \B_input[0]~input_o\,
	datab => \Add0~0_combout\,
	datad => VCC,
	combout => \Add0~1_combout\,
	cout => \Add0~2\);

-- Location: LCCOMB_X17_Y8_N2
\Mux7~2\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Mux7~2_combout\ = (\Mux7~0_combout\ & ((\Mux7~1_combout\ & ((\Add0~1_combout\))) # (!\Mux7~1_combout\ & (\B_input[0]~input_o\)))) # (!\Mux7~0_combout\ & (((\Mux7~1_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100001011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Mux7~0_combout\,
	datab => \B_input[0]~input_o\,
	datac => \Mux7~1_combout\,
	datad => \Add0~1_combout\,
	combout => \Mux7~2_combout\);

-- Location: LCCOMB_X17_Y8_N28
\Mux7~3\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Mux7~3_combout\ = (\B_input[0]~input_o\ & ((\Mux7~2_combout\) # ((\A_input[0]~input_o\ & \op_code[1]~input_o\)))) # (!\B_input[0]~input_o\ & (\Mux7~2_combout\ & ((\A_input[0]~input_o\) # (!\op_code[1]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111110000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \B_input[0]~input_o\,
	datab => \A_input[0]~input_o\,
	datac => \op_code[1]~input_o\,
	datad => \Mux7~2_combout\,
	combout => \Mux7~3_combout\);

-- Location: IOIBUF_X19_Y0_N29
\op_code[4]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_op_code(4),
	o => \op_code[4]~input_o\);

-- Location: IOIBUF_X10_Y19_N1
\op_code[3]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_op_code(3),
	o => \op_code[3]~input_o\);

-- Location: LCCOMB_X16_Y8_N4
\Mux7~4\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Mux7~4_combout\ = (!\op_code[4]~input_o\ & (!\op_code[3]~input_o\ & ((!\op_code[0]~input_o\) # (!\op_code[1]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000100010001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \op_code[4]~input_o\,
	datab => \op_code[3]~input_o\,
	datac => \op_code[1]~input_o\,
	datad => \op_code[0]~input_o\,
	combout => \Mux7~4_combout\);

-- Location: IOIBUF_X19_Y0_N8
\op_code[6]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_op_code(6),
	o => \op_code[6]~input_o\);

-- Location: LCCOMB_X16_Y4_N0
\Mux7~5\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Mux7~5_combout\ = (!\op_code[5]~input_o\ & (\Mux7~3_combout\ & (\Mux7~4_combout\ & !\op_code[6]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \op_code[5]~input_o\,
	datab => \Mux7~3_combout\,
	datac => \Mux7~4_combout\,
	datad => \op_code[6]~input_o\,
	combout => \Mux7~5_combout\);

-- Location: IOIBUF_X22_Y0_N15
\A_input[1]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A_input(1),
	o => \A_input[1]~input_o\);

-- Location: IOIBUF_X6_Y10_N15
\B_input[1]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B_input(1),
	o => \B_input[1]~input_o\);

-- Location: LCCOMB_X17_Y8_N30
\Add0~3\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Add0~3_combout\ = (!\op_code[2]~input_o\ & \A_input[1]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101000001010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \op_code[2]~input_o\,
	datac => \A_input[1]~input_o\,
	combout => \Add0~3_combout\);

-- Location: LCCOMB_X17_Y8_N14
\Add0~4\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Add0~4_combout\ = (\Add0~3_combout\ & ((\B_input[1]~input_o\ & (\Add0~2\ & VCC)) # (!\B_input[1]~input_o\ & (!\Add0~2\)))) # (!\Add0~3_combout\ & ((\B_input[1]~input_o\ & (!\Add0~2\)) # (!\B_input[1]~input_o\ & ((\Add0~2\) # (GND)))))
-- \Add0~5\ = CARRY((\Add0~3_combout\ & (!\B_input[1]~input_o\ & !\Add0~2\)) # (!\Add0~3_combout\ & ((!\Add0~2\) # (!\B_input[1]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \Add0~3_combout\,
	datab => \B_input[1]~input_o\,
	datad => VCC,
	cin => \Add0~2\,
	combout => \Add0~4_combout\,
	cout => \Add0~5\);

-- Location: LCCOMB_X17_Y8_N0
\Mux6~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Mux6~0_combout\ = (\Mux7~1_combout\ & (((\Add0~4_combout\) # (!\Mux7~0_combout\)))) # (!\Mux7~1_combout\ & (\B_input[1]~input_o\ & ((\Mux7~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110010010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Mux7~1_combout\,
	datab => \B_input[1]~input_o\,
	datac => \Add0~4_combout\,
	datad => \Mux7~0_combout\,
	combout => \Mux6~0_combout\);

-- Location: LCCOMB_X17_Y8_N10
\Mux6~1\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Mux6~1_combout\ = (\A_input[1]~input_o\ & ((\Mux6~0_combout\) # ((\op_code[1]~input_o\ & \B_input[1]~input_o\)))) # (!\A_input[1]~input_o\ & (\Mux6~0_combout\ & ((\B_input[1]~input_o\) # (!\op_code[1]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101110000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \A_input[1]~input_o\,
	datab => \op_code[1]~input_o\,
	datac => \B_input[1]~input_o\,
	datad => \Mux6~0_combout\,
	combout => \Mux6~1_combout\);

-- Location: LCCOMB_X16_Y4_N26
\Mux6~2\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Mux6~2_combout\ = (!\op_code[5]~input_o\ & (\Mux6~1_combout\ & (\Mux7~4_combout\ & !\op_code[6]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \op_code[5]~input_o\,
	datab => \Mux6~1_combout\,
	datac => \Mux7~4_combout\,
	datad => \op_code[6]~input_o\,
	combout => \Mux6~2_combout\);

-- Location: IOIBUF_X11_Y0_N29
\A_input[2]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A_input(2),
	o => \A_input[2]~input_o\);

-- Location: IOIBUF_X17_Y25_N22
\B_input[2]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B_input(2),
	o => \B_input[2]~input_o\);

-- Location: LCCOMB_X16_Y8_N22
\Add0~6\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Add0~6_combout\ = (!\op_code[2]~input_o\ & \A_input[2]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \op_code[2]~input_o\,
	datad => \A_input[2]~input_o\,
	combout => \Add0~6_combout\);

-- Location: LCCOMB_X17_Y8_N16
\Add0~7\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Add0~7_combout\ = ((\B_input[2]~input_o\ $ (\Add0~6_combout\ $ (!\Add0~5\)))) # (GND)
-- \Add0~8\ = CARRY((\B_input[2]~input_o\ & ((\Add0~6_combout\) # (!\Add0~5\))) # (!\B_input[2]~input_o\ & (\Add0~6_combout\ & !\Add0~5\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \B_input[2]~input_o\,
	datab => \Add0~6_combout\,
	datad => VCC,
	cin => \Add0~5\,
	combout => \Add0~7_combout\,
	cout => \Add0~8\);

-- Location: LCCOMB_X16_Y8_N0
\Mux5~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Mux5~0_combout\ = (\Mux7~0_combout\ & ((\Mux7~1_combout\ & ((\Add0~7_combout\))) # (!\Mux7~1_combout\ & (\B_input[2]~input_o\)))) # (!\Mux7~0_combout\ & (\Mux7~1_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110110001100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Mux7~0_combout\,
	datab => \Mux7~1_combout\,
	datac => \B_input[2]~input_o\,
	datad => \Add0~7_combout\,
	combout => \Mux5~0_combout\);

-- Location: LCCOMB_X16_Y8_N18
\Mux5~1\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Mux5~1_combout\ = (\A_input[2]~input_o\ & ((\Mux5~0_combout\) # ((\op_code[1]~input_o\ & \B_input[2]~input_o\)))) # (!\A_input[2]~input_o\ & (\Mux5~0_combout\ & ((\B_input[2]~input_o\) # (!\op_code[1]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101110000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \A_input[2]~input_o\,
	datab => \op_code[1]~input_o\,
	datac => \B_input[2]~input_o\,
	datad => \Mux5~0_combout\,
	combout => \Mux5~1_combout\);

-- Location: LCCOMB_X16_Y4_N12
\Mux5~2\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Mux5~2_combout\ = (!\op_code[5]~input_o\ & (\Mux5~1_combout\ & (\Mux7~4_combout\ & !\op_code[6]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \op_code[5]~input_o\,
	datab => \Mux5~1_combout\,
	datac => \Mux7~4_combout\,
	datad => \op_code[6]~input_o\,
	combout => \Mux5~2_combout\);

-- Location: IOIBUF_X13_Y0_N29
\A_input[3]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A_input(3),
	o => \A_input[3]~input_o\);

-- Location: IOIBUF_X6_Y10_N8
\B_input[3]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B_input(3),
	o => \B_input[3]~input_o\);

-- Location: LCCOMB_X16_Y8_N12
\Add0~9\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Add0~9_combout\ = (!\op_code[2]~input_o\ & \A_input[3]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011000000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \op_code[2]~input_o\,
	datac => \A_input[3]~input_o\,
	combout => \Add0~9_combout\);

-- Location: LCCOMB_X17_Y8_N18
\Add0~10\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Add0~10_combout\ = (\Add0~9_combout\ & ((\B_input[3]~input_o\ & (\Add0~8\ & VCC)) # (!\B_input[3]~input_o\ & (!\Add0~8\)))) # (!\Add0~9_combout\ & ((\B_input[3]~input_o\ & (!\Add0~8\)) # (!\B_input[3]~input_o\ & ((\Add0~8\) # (GND)))))
-- \Add0~11\ = CARRY((\Add0~9_combout\ & (!\B_input[3]~input_o\ & !\Add0~8\)) # (!\Add0~9_combout\ & ((!\Add0~8\) # (!\B_input[3]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \Add0~9_combout\,
	datab => \B_input[3]~input_o\,
	datad => VCC,
	cin => \Add0~8\,
	combout => \Add0~10_combout\,
	cout => \Add0~11\);

-- Location: LCCOMB_X16_Y8_N30
\Mux4~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Mux4~0_combout\ = (\Mux7~0_combout\ & ((\Mux7~1_combout\ & ((\Add0~10_combout\))) # (!\Mux7~1_combout\ & (\B_input[3]~input_o\)))) # (!\Mux7~0_combout\ & (\Mux7~1_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110110001100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Mux7~0_combout\,
	datab => \Mux7~1_combout\,
	datac => \B_input[3]~input_o\,
	datad => \Add0~10_combout\,
	combout => \Mux4~0_combout\);

-- Location: LCCOMB_X16_Y8_N16
\Mux4~1\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Mux4~1_combout\ = (\A_input[3]~input_o\ & ((\Mux4~0_combout\) # ((\op_code[1]~input_o\ & \B_input[3]~input_o\)))) # (!\A_input[3]~input_o\ & (\Mux4~0_combout\ & ((\B_input[3]~input_o\) # (!\op_code[1]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100010110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \A_input[3]~input_o\,
	datab => \op_code[1]~input_o\,
	datac => \Mux4~0_combout\,
	datad => \B_input[3]~input_o\,
	combout => \Mux4~1_combout\);

-- Location: LCCOMB_X16_Y4_N30
\Mux4~2\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Mux4~2_combout\ = (!\op_code[5]~input_o\ & (\Mux4~1_combout\ & (\Mux7~4_combout\ & !\op_code[6]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \op_code[5]~input_o\,
	datab => \Mux4~1_combout\,
	datac => \Mux7~4_combout\,
	datad => \op_code[6]~input_o\,
	combout => \Mux4~2_combout\);

-- Location: IOIBUF_X13_Y0_N8
\B_input[4]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B_input(4),
	o => \B_input[4]~input_o\);

-- Location: IOIBUF_X19_Y0_N22
\A_input[4]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A_input(4),
	o => \A_input[4]~input_o\);

-- Location: LCCOMB_X16_Y9_N16
\Add0~12\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Add0~12_combout\ = (!\op_code[2]~input_o\ & \A_input[4]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \op_code[2]~input_o\,
	datad => \A_input[4]~input_o\,
	combout => \Add0~12_combout\);

-- Location: LCCOMB_X17_Y8_N20
\Add0~13\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Add0~13_combout\ = ((\Add0~12_combout\ $ (\B_input[4]~input_o\ $ (!\Add0~11\)))) # (GND)
-- \Add0~14\ = CARRY((\Add0~12_combout\ & ((\B_input[4]~input_o\) # (!\Add0~11\))) # (!\Add0~12_combout\ & (\B_input[4]~input_o\ & !\Add0~11\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \Add0~12_combout\,
	datab => \B_input[4]~input_o\,
	datad => VCC,
	cin => \Add0~11\,
	combout => \Add0~13_combout\,
	cout => \Add0~14\);

-- Location: LCCOMB_X16_Y8_N10
\Mux3~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Mux3~0_combout\ = (\Mux7~1_combout\ & (((\Add0~13_combout\) # (!\Mux7~0_combout\)))) # (!\Mux7~1_combout\ & (\B_input[4]~input_o\ & ((\Mux7~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110001011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \B_input[4]~input_o\,
	datab => \Mux7~1_combout\,
	datac => \Add0~13_combout\,
	datad => \Mux7~0_combout\,
	combout => \Mux3~0_combout\);

-- Location: LCCOMB_X16_Y8_N20
\Mux3~1\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Mux3~1_combout\ = (\Mux3~0_combout\ & (((\B_input[4]~input_o\) # (\A_input[4]~input_o\)) # (!\op_code[1]~input_o\))) # (!\Mux3~0_combout\ & (\op_code[1]~input_o\ & (\B_input[4]~input_o\ & \A_input[4]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110101010100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Mux3~0_combout\,
	datab => \op_code[1]~input_o\,
	datac => \B_input[4]~input_o\,
	datad => \A_input[4]~input_o\,
	combout => \Mux3~1_combout\);

-- Location: LCCOMB_X16_Y4_N8
\Mux3~2\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Mux3~2_combout\ = (!\op_code[5]~input_o\ & (\Mux7~4_combout\ & (\Mux3~1_combout\ & !\op_code[6]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \op_code[5]~input_o\,
	datab => \Mux7~4_combout\,
	datac => \Mux3~1_combout\,
	datad => \op_code[6]~input_o\,
	combout => \Mux3~2_combout\);

-- Location: IOIBUF_X17_Y0_N1
\B_input[5]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B_input(5),
	o => \B_input[5]~input_o\);

-- Location: IOIBUF_X10_Y18_N22
\A_input[5]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A_input(5),
	o => \A_input[5]~input_o\);

-- Location: LCCOMB_X18_Y12_N16
\Add0~15\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Add0~15_combout\ = (!\op_code[2]~input_o\ & \A_input[5]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \op_code[2]~input_o\,
	datad => \A_input[5]~input_o\,
	combout => \Add0~15_combout\);

-- Location: LCCOMB_X17_Y8_N22
\Add0~16\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Add0~16_combout\ = (\B_input[5]~input_o\ & ((\Add0~15_combout\ & (\Add0~14\ & VCC)) # (!\Add0~15_combout\ & (!\Add0~14\)))) # (!\B_input[5]~input_o\ & ((\Add0~15_combout\ & (!\Add0~14\)) # (!\Add0~15_combout\ & ((\Add0~14\) # (GND)))))
-- \Add0~17\ = CARRY((\B_input[5]~input_o\ & (!\Add0~15_combout\ & !\Add0~14\)) # (!\B_input[5]~input_o\ & ((!\Add0~14\) # (!\Add0~15_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \B_input[5]~input_o\,
	datab => \Add0~15_combout\,
	datad => VCC,
	cin => \Add0~14\,
	combout => \Add0~16_combout\,
	cout => \Add0~17\);

-- Location: LCCOMB_X17_Y8_N4
\Mux2~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Mux2~0_combout\ = (\Mux7~1_combout\ & (((\Add0~16_combout\) # (!\Mux7~0_combout\)))) # (!\Mux7~1_combout\ & (\B_input[5]~input_o\ & ((\Mux7~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100101011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \B_input[5]~input_o\,
	datab => \Add0~16_combout\,
	datac => \Mux7~1_combout\,
	datad => \Mux7~0_combout\,
	combout => \Mux2~0_combout\);

-- Location: LCCOMB_X17_Y8_N6
\Mux2~1\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Mux2~1_combout\ = (\B_input[5]~input_o\ & ((\Mux2~0_combout\) # ((\op_code[1]~input_o\ & \A_input[5]~input_o\)))) # (!\B_input[5]~input_o\ & (\Mux2~0_combout\ & ((\A_input[5]~input_o\) # (!\op_code[1]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100010110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \B_input[5]~input_o\,
	datab => \op_code[1]~input_o\,
	datac => \Mux2~0_combout\,
	datad => \A_input[5]~input_o\,
	combout => \Mux2~1_combout\);

-- Location: LCCOMB_X16_Y4_N10
\Mux2~2\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Mux2~2_combout\ = (!\op_code[5]~input_o\ & (\Mux2~1_combout\ & (\Mux7~4_combout\ & !\op_code[6]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \op_code[5]~input_o\,
	datab => \Mux2~1_combout\,
	datac => \Mux7~4_combout\,
	datad => \op_code[6]~input_o\,
	combout => \Mux2~2_combout\);

-- Location: IOIBUF_X6_Y10_N1
\A_input[6]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A_input(6),
	o => \A_input[6]~input_o\);

-- Location: IOIBUF_X29_Y25_N1
\B_input[6]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B_input(6),
	o => \B_input[6]~input_o\);

-- Location: LCCOMB_X18_Y12_N10
\Add0~18\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Add0~18_combout\ = (!\op_code[2]~input_o\ & \A_input[6]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \op_code[2]~input_o\,
	datad => \A_input[6]~input_o\,
	combout => \Add0~18_combout\);

-- Location: LCCOMB_X17_Y8_N24
\Add0~19\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Add0~19_combout\ = ((\B_input[6]~input_o\ $ (\Add0~18_combout\ $ (!\Add0~17\)))) # (GND)
-- \Add0~20\ = CARRY((\B_input[6]~input_o\ & ((\Add0~18_combout\) # (!\Add0~17\))) # (!\B_input[6]~input_o\ & (\Add0~18_combout\ & !\Add0~17\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \B_input[6]~input_o\,
	datab => \Add0~18_combout\,
	datad => VCC,
	cin => \Add0~17\,
	combout => \Add0~19_combout\,
	cout => \Add0~20\);

-- Location: LCCOMB_X16_Y8_N14
\Mux1~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Mux1~0_combout\ = (\Mux7~0_combout\ & ((\Mux7~1_combout\ & (\Add0~19_combout\)) # (!\Mux7~1_combout\ & ((\B_input[6]~input_o\))))) # (!\Mux7~0_combout\ & (((\Mux7~1_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101101011010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Mux7~0_combout\,
	datab => \Add0~19_combout\,
	datac => \Mux7~1_combout\,
	datad => \B_input[6]~input_o\,
	combout => \Mux1~0_combout\);

-- Location: LCCOMB_X16_Y8_N24
\Mux1~1\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Mux1~1_combout\ = (\A_input[6]~input_o\ & ((\Mux1~0_combout\) # ((\op_code[1]~input_o\ & \B_input[6]~input_o\)))) # (!\A_input[6]~input_o\ & (\Mux1~0_combout\ & ((\B_input[6]~input_o\) # (!\op_code[1]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110110010001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \A_input[6]~input_o\,
	datab => \Mux1~0_combout\,
	datac => \op_code[1]~input_o\,
	datad => \B_input[6]~input_o\,
	combout => \Mux1~1_combout\);

-- Location: LCCOMB_X16_Y4_N28
\Mux1~2\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Mux1~2_combout\ = (!\op_code[5]~input_o\ & (\Mux1~1_combout\ & (\Mux7~4_combout\ & !\op_code[6]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \op_code[5]~input_o\,
	datab => \Mux1~1_combout\,
	datac => \Mux7~4_combout\,
	datad => \op_code[6]~input_o\,
	combout => \Mux1~2_combout\);

-- Location: IOIBUF_X6_Y10_N22
\B_input[7]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B_input(7),
	o => \B_input[7]~input_o\);

-- Location: IOIBUF_X13_Y0_N22
\A_input[7]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A_input(7),
	o => \A_input[7]~input_o\);

-- Location: LCCOMB_X16_Y8_N2
\Add0~21\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Add0~21_combout\ = (!\op_code[2]~input_o\ & \A_input[7]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011000000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \op_code[2]~input_o\,
	datac => \A_input[7]~input_o\,
	combout => \Add0~21_combout\);

-- Location: LCCOMB_X17_Y8_N26
\Add0~22\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Add0~22_combout\ = \B_input[7]~input_o\ $ (\Add0~20\ $ (\Add0~21_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010101011010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \B_input[7]~input_o\,
	datad => \Add0~21_combout\,
	cin => \Add0~20\,
	combout => \Add0~22_combout\);

-- Location: LCCOMB_X16_Y8_N28
\Mux0~0\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Mux0~0_combout\ = (\Mux7~1_combout\ & (((\Add0~22_combout\) # (!\Mux7~0_combout\)))) # (!\Mux7~1_combout\ & (\B_input[7]~input_o\ & ((\Mux7~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110001011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \B_input[7]~input_o\,
	datab => \Mux7~1_combout\,
	datac => \Add0~22_combout\,
	datad => \Mux7~0_combout\,
	combout => \Mux0~0_combout\);

-- Location: LCCOMB_X16_Y8_N6
\Mux0~1\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Mux0~1_combout\ = (\B_input[7]~input_o\ & ((\Mux0~0_combout\) # ((\op_code[1]~input_o\ & \A_input[7]~input_o\)))) # (!\B_input[7]~input_o\ & (\Mux0~0_combout\ & ((\A_input[7]~input_o\) # (!\op_code[1]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101110000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \B_input[7]~input_o\,
	datab => \op_code[1]~input_o\,
	datac => \A_input[7]~input_o\,
	datad => \Mux0~0_combout\,
	combout => \Mux0~1_combout\);

-- Location: LCCOMB_X16_Y4_N22
\Mux0~2\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \Mux0~2_combout\ = (!\op_code[5]~input_o\ & (\Mux0~1_combout\ & (\Mux7~4_combout\ & !\op_code[6]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \op_code[5]~input_o\,
	datab => \Mux0~1_combout\,
	datac => \Mux7~4_combout\,
	datad => \op_code[6]~input_o\,
	combout => \Mux0~2_combout\);

-- Location: UNVM_X0_Y11_N40
\~QUARTUS_CREATED_UNVM~\ : fiftyfivenm_unvm
-- pragma translate_off
GENERIC MAP (
	addr_range1_end_addr => -1,
	addr_range1_offset => -1,
	addr_range2_end_addr => -1,
	addr_range2_offset => -1,
	addr_range3_offset => -1,
	is_compressed_image => "false",
	is_dual_boot => "false",
	is_eram_skip => "false",
	max_ufm_valid_addr => -1,
	max_valid_addr => -1,
	min_ufm_valid_addr => -1,
	min_valid_addr => -1,
	part_name => "quartus_created_unvm",
	reserve_block => "true")
-- pragma translate_on
PORT MAP (
	nosc_ena => \~QUARTUS_CREATED_GND~I_combout\,
	xe_ye => \~QUARTUS_CREATED_GND~I_combout\,
	se => \~QUARTUS_CREATED_GND~I_combout\,
	busy => \~QUARTUS_CREATED_UNVM~~busy\);

-- Location: ADCBLOCK_X10_Y24_N0
\~QUARTUS_CREATED_ADC1~\ : fiftyfivenm_adcblock
-- pragma translate_off
GENERIC MAP (
	analog_input_pin_mask => 0,
	clkdiv => 1,
	device_partname_fivechar_prefix => "none",
	is_this_first_or_second_adc => 1,
	prescalar => 0,
	pwd => 1,
	refsel => 0,
	reserve_block => "true",
	testbits => 66,
	tsclkdiv => 1,
	tsclksel => 0)
-- pragma translate_on
PORT MAP (
	soc => \~QUARTUS_CREATED_GND~I_combout\,
	usr_pwd => VCC,
	tsen => \~QUARTUS_CREATED_GND~I_combout\,
	chsel => \~QUARTUS_CREATED_ADC1~_CHSEL_bus\,
	eoc => \~QUARTUS_CREATED_ADC1~~eoc\);

ww_ALU_output(0) <= \ALU_output[0]~output_o\;

ww_ALU_output(1) <= \ALU_output[1]~output_o\;

ww_ALU_output(2) <= \ALU_output[2]~output_o\;

ww_ALU_output(3) <= \ALU_output[3]~output_o\;

ww_ALU_output(4) <= \ALU_output[4]~output_o\;

ww_ALU_output(5) <= \ALU_output[5]~output_o\;

ww_ALU_output(6) <= \ALU_output[6]~output_o\;

ww_ALU_output(7) <= \ALU_output[7]~output_o\;
END structure;


