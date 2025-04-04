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

-- DATE "03/17/2025 13:37:24"

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

ENTITY 	hard_block IS
    PORT (
	devoe : IN std_logic;
	devclrn : IN std_logic;
	devpor : IN std_logic
	);
END hard_block;

-- Design Ports Information
-- ~ALTERA_TMS~	=>  Location: PIN_16,	 I/O Standard: 2.5 V Schmitt Trigger,	 Current Strength: Default
-- ~ALTERA_TCK~	=>  Location: PIN_18,	 I/O Standard: 2.5 V Schmitt Trigger,	 Current Strength: Default
-- ~ALTERA_TDI~	=>  Location: PIN_19,	 I/O Standard: 2.5 V Schmitt Trigger,	 Current Strength: Default
-- ~ALTERA_TDO~	=>  Location: PIN_20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_CONFIG_SEL~	=>  Location: PIN_126,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_nCONFIG~	=>  Location: PIN_129,	 I/O Standard: 2.5 V Schmitt Trigger,	 Current Strength: Default
-- ~ALTERA_nSTATUS~	=>  Location: PIN_136,	 I/O Standard: 2.5 V Schmitt Trigger,	 Current Strength: Default
-- ~ALTERA_CONF_DONE~	=>  Location: PIN_138,	 I/O Standard: 2.5 V Schmitt Trigger,	 Current Strength: Default


ARCHITECTURE structure OF hard_block IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL a_aALTERA_TMS_a_apadout : std_logic;
SIGNAL a_aALTERA_TCK_a_apadout : std_logic;
SIGNAL a_aALTERA_TDI_a_apadout : std_logic;
SIGNAL a_aALTERA_CONFIG_SEL_a_apadout : std_logic;
SIGNAL a_aALTERA_nCONFIG_a_apadout : std_logic;
SIGNAL a_aALTERA_nSTATUS_a_apadout : std_logic;
SIGNAL a_aALTERA_CONF_DONE_a_apadout : std_logic;
SIGNAL a_aALTERA_TMS_a_aibuf_o : std_logic;
SIGNAL a_aALTERA_TCK_a_aibuf_o : std_logic;
SIGNAL a_aALTERA_TDI_a_aibuf_o : std_logic;
SIGNAL a_aALTERA_CONFIG_SEL_a_aibuf_o : std_logic;
SIGNAL a_aALTERA_nCONFIG_a_aibuf_o : std_logic;
SIGNAL a_aALTERA_nSTATUS_a_aibuf_o : std_logic;
SIGNAL a_aALTERA_CONF_DONE_a_aibuf_o : std_logic;

BEGIN

ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
END structure;


LIBRARY FIFTYFIVENM;
LIBRARY IEEE;
USE FIFTYFIVENM.FIFTYFIVENM_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	two_to_four_decoder IS
    PORT (
	A : IN std_logic_vector(1 DOWNTO 0);
	Y : BUFFER std_logic_vector(3 DOWNTO 0)
	);
END two_to_four_decoder;

-- Design Ports Information
-- Y[0]	=>  Location: PIN_55,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Y[1]	=>  Location: PIN_47,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Y[2]	=>  Location: PIN_46,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Y[3]	=>  Location: PIN_43,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A[0]	=>  Location: PIN_102,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A[1]	=>  Location: PIN_100,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF two_to_four_decoder IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_A : std_logic_vector(1 DOWNTO 0);
SIGNAL ww_Y : std_logic_vector(3 DOWNTO 0);
SIGNAL a_aQUARTUS_CREATED_ADC1_a_CHSEL_bus : std_logic_vector(4 DOWNTO 0);
SIGNAL a_aQUARTUS_CREATED_GND_aI_combout : std_logic;
SIGNAL a_aQUARTUS_CREATED_UNVM_a_abusy : std_logic;
SIGNAL a_aQUARTUS_CREATED_ADC1_a_aeoc : std_logic;
SIGNAL Y_a0_a_aoutput_o : std_logic;
SIGNAL Y_a1_a_aoutput_o : std_logic;
SIGNAL Y_a2_a_aoutput_o : std_logic;
SIGNAL Y_a3_a_aoutput_o : std_logic;
SIGNAL A_a0_a_ainput_o : std_logic;
SIGNAL A_a1_a_ainput_o : std_logic;
SIGNAL Mux3_a0_combout : std_logic;
SIGNAL Mux1_a0_combout : std_logic;
SIGNAL Mux1_a1_combout : std_logic;
SIGNAL Mux1_a2_combout : std_logic;
SIGNAL ALT_INV_Mux3_a0_combout : std_logic;

COMPONENT hard_block
    PORT (
	devoe : IN std_logic;
	devclrn : IN std_logic;
	devpor : IN std_logic);
END COMPONENT;

BEGIN

ww_A <= A;
Y <= ww_Y;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

a_aQUARTUS_CREATED_ADC1_a_CHSEL_bus <= (a_aQUARTUS_CREATED_GND_aI_combout & a_aQUARTUS_CREATED_GND_aI_combout & a_aQUARTUS_CREATED_GND_aI_combout & a_aQUARTUS_CREATED_GND_aI_combout & a_aQUARTUS_CREATED_GND_aI_combout);
ALT_INV_Mux3_a0_combout <= NOT Mux3_a0_combout;
auto_generated_inst : hard_block
PORT MAP (
	devoe => ww_devoe,
	devclrn => ww_devclrn,
	devpor => ww_devpor);

-- Location: LCCOMB_X11_Y24_N24
a_aQUARTUS_CREATED_GND_aI : fiftyfivenm_lcell_comb
-- Equation(s):
-- a_aQUARTUS_CREATED_GND_aI_combout = GND

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	combout => a_aQUARTUS_CREATED_GND_aI_combout);

-- Location: IOOBUF_X15_Y0_N23
Y_a0_a_aoutput : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => ALT_INV_Mux3_a0_combout,
	devoe => ww_devoe,
	o => Y_a0_a_aoutput_o);

-- Location: IOOBUF_X11_Y0_N30
Y_a1_a_aoutput : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => Mux1_a0_combout,
	devoe => ww_devoe,
	o => Y_a1_a_aoutput_o);

-- Location: IOOBUF_X9_Y0_N2
Y_a2_a_aoutput : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => Mux1_a1_combout,
	devoe => ww_devoe,
	o => Y_a2_a_aoutput_o);

-- Location: IOOBUF_X6_Y0_N16
Y_a3_a_aoutput : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => Mux1_a2_combout,
	devoe => ww_devoe,
	o => Y_a3_a_aoutput_o);

-- Location: IOIBUF_X31_Y19_N1
A_a0_a_ainput : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A(0),
	o => A_a0_a_ainput_o);

-- Location: IOIBUF_X31_Y19_N8
A_a1_a_ainput : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A(1),
	o => A_a1_a_ainput_o);

-- Location: LCCOMB_X16_Y4_N8
Mux3_a0 : fiftyfivenm_lcell_comb
-- Equation(s):
-- Mux3_a0_combout = (A_a0_a_ainput_o) # (A_a1_a_ainput_o)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => A_a0_a_ainput_o,
	datad => A_a1_a_ainput_o,
	combout => Mux3_a0_combout);

-- Location: LCCOMB_X16_Y4_N26
Mux1_a0 : fiftyfivenm_lcell_comb
-- Equation(s):
-- Mux1_a0_combout = (A_a0_a_ainput_o & !A_a1_a_ainput_o)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => A_a0_a_ainput_o,
	datad => A_a1_a_ainput_o,
	combout => Mux1_a0_combout);

-- Location: LCCOMB_X16_Y4_N28
Mux1_a1 : fiftyfivenm_lcell_comb
-- Equation(s):
-- Mux1_a1_combout = (!A_a0_a_ainput_o & A_a1_a_ainput_o)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => A_a0_a_ainput_o,
	datad => A_a1_a_ainput_o,
	combout => Mux1_a1_combout);

-- Location: LCCOMB_X16_Y4_N14
Mux1_a2 : fiftyfivenm_lcell_comb
-- Equation(s):
-- Mux1_a2_combout = (A_a0_a_ainput_o & A_a1_a_ainput_o)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => A_a0_a_ainput_o,
	datad => A_a1_a_ainput_o,
	combout => Mux1_a2_combout);

-- Location: UNVM_X0_Y11_N40
a_aQUARTUS_CREATED_UNVM_a : fiftyfivenm_unvm
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
	nosc_ena => a_aQUARTUS_CREATED_GND_aI_combout,
	xe_ye => a_aQUARTUS_CREATED_GND_aI_combout,
	se => a_aQUARTUS_CREATED_GND_aI_combout,
	busy => a_aQUARTUS_CREATED_UNVM_a_abusy);

-- Location: ADCBLOCK_X10_Y24_N0
a_aQUARTUS_CREATED_ADC1_a : fiftyfivenm_adcblock
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
	soc => a_aQUARTUS_CREATED_GND_aI_combout,
	usr_pwd => VCC,
	tsen => a_aQUARTUS_CREATED_GND_aI_combout,
	chsel => a_aQUARTUS_CREATED_ADC1_a_CHSEL_bus,
	eoc => a_aQUARTUS_CREATED_ADC1_a_aeoc);

ww_Y(0) <= Y_a0_a_aoutput_o;

ww_Y(1) <= Y_a1_a_aoutput_o;

ww_Y(2) <= Y_a2_a_aoutput_o;

ww_Y(3) <= Y_a3_a_aoutput_o;
END structure;


