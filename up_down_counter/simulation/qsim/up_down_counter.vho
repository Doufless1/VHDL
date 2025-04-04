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

-- DATE "03/24/2025 12:27:04"

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


LIBRARY ALTERA;
LIBRARY FIFTYFIVENM;
LIBRARY IEEE;
USE ALTERA.ALTERA_PRIMITIVES_COMPONENTS.ALL;
USE FIFTYFIVENM.FIFTYFIVENM_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	up_down_counter IS
    PORT (
	Clock : IN std_logic;
	Reset : IN std_logic;
	Enable : IN std_logic;
	Up_Down : IN std_logic;
	Count : OUT std_logic_vector(7 DOWNTO 0)
	);
END up_down_counter;

-- Design Ports Information
-- Count[0]	=>  Location: PIN_52,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Count[1]	=>  Location: PIN_48,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Count[2]	=>  Location: PIN_54,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Count[3]	=>  Location: PIN_47,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Count[4]	=>  Location: PIN_55,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Count[5]	=>  Location: PIN_58,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Count[6]	=>  Location: PIN_50,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Count[7]	=>  Location: PIN_59,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Clock	=>  Location: PIN_28,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Reset	=>  Location: PIN_29,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Enable	=>  Location: PIN_57,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Up_Down	=>  Location: PIN_56,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF up_down_counter IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_Clock : std_logic;
SIGNAL ww_Reset : std_logic;
SIGNAL ww_Enable : std_logic;
SIGNAL ww_Up_Down : std_logic;
SIGNAL ww_Count : std_logic_vector(7 DOWNTO 0);
SIGNAL \~QUARTUS_CREATED_ADC1~_CHSEL_bus\ : std_logic_vector(4 DOWNTO 0);
SIGNAL \Reset~inputclkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \Clock~inputclkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \~QUARTUS_CREATED_GND~I_combout\ : std_logic;
SIGNAL \~QUARTUS_CREATED_UNVM~~busy\ : std_logic;
SIGNAL \~QUARTUS_CREATED_ADC1~~eoc\ : std_logic;
SIGNAL \Count[0]~output_o\ : std_logic;
SIGNAL \Count[1]~output_o\ : std_logic;
SIGNAL \Count[2]~output_o\ : std_logic;
SIGNAL \Count[3]~output_o\ : std_logic;
SIGNAL \Count[4]~output_o\ : std_logic;
SIGNAL \Count[5]~output_o\ : std_logic;
SIGNAL \Count[6]~output_o\ : std_logic;
SIGNAL \Count[7]~output_o\ : std_logic;
SIGNAL \Clock~input_o\ : std_logic;
SIGNAL \Clock~inputclkctrl_outclk\ : std_logic;
SIGNAL \internal_count[0]~8_combout\ : std_logic;
SIGNAL \Reset~input_o\ : std_logic;
SIGNAL \Reset~inputclkctrl_outclk\ : std_logic;
SIGNAL \Enable~input_o\ : std_logic;
SIGNAL \Up_Down~input_o\ : std_logic;
SIGNAL \internal_count[0]~9\ : std_logic;
SIGNAL \internal_count[1]~10_combout\ : std_logic;
SIGNAL \internal_count[1]~11\ : std_logic;
SIGNAL \internal_count[2]~12_combout\ : std_logic;
SIGNAL \internal_count[2]~13\ : std_logic;
SIGNAL \internal_count[3]~14_combout\ : std_logic;
SIGNAL \internal_count[3]~15\ : std_logic;
SIGNAL \internal_count[4]~16_combout\ : std_logic;
SIGNAL \internal_count[4]~17\ : std_logic;
SIGNAL \internal_count[5]~18_combout\ : std_logic;
SIGNAL \internal_count[5]~19\ : std_logic;
SIGNAL \internal_count[6]~20_combout\ : std_logic;
SIGNAL \internal_count[6]~21\ : std_logic;
SIGNAL \internal_count[7]~22_combout\ : std_logic;
SIGNAL internal_count : std_logic_vector(7 DOWNTO 0);
SIGNAL \ALT_INV_Reset~inputclkctrl_outclk\ : std_logic;

COMPONENT hard_block
    PORT (
	devoe : IN std_logic;
	devclrn : IN std_logic;
	devpor : IN std_logic);
END COMPONENT;

BEGIN

ww_Clock <= Clock;
ww_Reset <= Reset;
ww_Enable <= Enable;
ww_Up_Down <= Up_Down;
Count <= ww_Count;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

\~QUARTUS_CREATED_ADC1~_CHSEL_bus\ <= (\~QUARTUS_CREATED_GND~I_combout\ & \~QUARTUS_CREATED_GND~I_combout\ & \~QUARTUS_CREATED_GND~I_combout\ & \~QUARTUS_CREATED_GND~I_combout\ & \~QUARTUS_CREATED_GND~I_combout\);

\Reset~inputclkctrl_INCLK_bus\ <= (vcc & vcc & vcc & \Reset~input_o\);

\Clock~inputclkctrl_INCLK_bus\ <= (vcc & vcc & vcc & \Clock~input_o\);
\ALT_INV_Reset~inputclkctrl_outclk\ <= NOT \Reset~inputclkctrl_outclk\;
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

-- Location: IOOBUF_X11_Y0_N2
\Count[0]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => internal_count(0),
	devoe => ww_devoe,
	o => \Count[0]~output_o\);

-- Location: IOOBUF_X11_Y0_N23
\Count[1]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => internal_count(1),
	devoe => ww_devoe,
	o => \Count[1]~output_o\);

-- Location: IOOBUF_X13_Y0_N16
\Count[2]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => internal_count(2),
	devoe => ww_devoe,
	o => \Count[2]~output_o\);

-- Location: IOOBUF_X11_Y0_N30
\Count[3]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => internal_count(3),
	devoe => ww_devoe,
	o => \Count[3]~output_o\);

-- Location: IOOBUF_X15_Y0_N23
\Count[4]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => internal_count(4),
	devoe => ww_devoe,
	o => \Count[4]~output_o\);

-- Location: IOOBUF_X17_Y0_N23
\Count[5]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => internal_count(5),
	devoe => ww_devoe,
	o => \Count[5]~output_o\);

-- Location: IOOBUF_X11_Y0_N9
\Count[6]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => internal_count(6),
	devoe => ww_devoe,
	o => \Count[6]~output_o\);

-- Location: IOOBUF_X17_Y0_N2
\Count[7]~output\ : fiftyfivenm_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => internal_count(7),
	devoe => ww_devoe,
	o => \Count[7]~output_o\);

-- Location: IOIBUF_X0_Y6_N15
\Clock~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Clock,
	o => \Clock~input_o\);

-- Location: CLKCTRL_G3
\Clock~inputclkctrl\ : fiftyfivenm_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \Clock~inputclkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \Clock~inputclkctrl_outclk\);

-- Location: LCCOMB_X15_Y1_N14
\internal_count[0]~8\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \internal_count[0]~8_combout\ = internal_count(0) $ (VCC)
-- \internal_count[0]~9\ = CARRY(internal_count(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001111001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => internal_count(0),
	datad => VCC,
	combout => \internal_count[0]~8_combout\,
	cout => \internal_count[0]~9\);

-- Location: IOIBUF_X0_Y6_N22
\Reset~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Reset,
	o => \Reset~input_o\);

-- Location: CLKCTRL_G4
\Reset~inputclkctrl\ : fiftyfivenm_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \Reset~inputclkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \Reset~inputclkctrl_outclk\);

-- Location: IOIBUF_X17_Y0_N29
\Enable~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Enable,
	o => \Enable~input_o\);

-- Location: FF_X15_Y1_N15
\internal_count[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \Clock~inputclkctrl_outclk\,
	d => \internal_count[0]~8_combout\,
	clrn => \ALT_INV_Reset~inputclkctrl_outclk\,
	ena => \Enable~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => internal_count(0));

-- Location: IOIBUF_X15_Y0_N15
\Up_Down~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Up_Down,
	o => \Up_Down~input_o\);

-- Location: LCCOMB_X15_Y1_N16
\internal_count[1]~10\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \internal_count[1]~10_combout\ = (\Up_Down~input_o\ & ((internal_count(1) & (!\internal_count[0]~9\)) # (!internal_count(1) & ((\internal_count[0]~9\) # (GND))))) # (!\Up_Down~input_o\ & ((internal_count(1) & (\internal_count[0]~9\ & VCC)) # 
-- (!internal_count(1) & (!\internal_count[0]~9\))))
-- \internal_count[1]~11\ = CARRY((\Up_Down~input_o\ & ((!\internal_count[0]~9\) # (!internal_count(1)))) # (!\Up_Down~input_o\ & (!internal_count(1) & !\internal_count[0]~9\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100100101011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \Up_Down~input_o\,
	datab => internal_count(1),
	datad => VCC,
	cin => \internal_count[0]~9\,
	combout => \internal_count[1]~10_combout\,
	cout => \internal_count[1]~11\);

-- Location: FF_X15_Y1_N17
\internal_count[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \Clock~inputclkctrl_outclk\,
	d => \internal_count[1]~10_combout\,
	clrn => \ALT_INV_Reset~inputclkctrl_outclk\,
	ena => \Enable~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => internal_count(1));

-- Location: LCCOMB_X15_Y1_N18
\internal_count[2]~12\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \internal_count[2]~12_combout\ = ((\Up_Down~input_o\ $ (internal_count(2) $ (\internal_count[1]~11\)))) # (GND)
-- \internal_count[2]~13\ = CARRY((\Up_Down~input_o\ & (internal_count(2) & !\internal_count[1]~11\)) # (!\Up_Down~input_o\ & ((internal_count(2)) # (!\internal_count[1]~11\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011001001101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \Up_Down~input_o\,
	datab => internal_count(2),
	datad => VCC,
	cin => \internal_count[1]~11\,
	combout => \internal_count[2]~12_combout\,
	cout => \internal_count[2]~13\);

-- Location: FF_X15_Y1_N19
\internal_count[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \Clock~inputclkctrl_outclk\,
	d => \internal_count[2]~12_combout\,
	clrn => \ALT_INV_Reset~inputclkctrl_outclk\,
	ena => \Enable~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => internal_count(2));

-- Location: LCCOMB_X15_Y1_N20
\internal_count[3]~14\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \internal_count[3]~14_combout\ = (\Up_Down~input_o\ & ((internal_count(3) & (!\internal_count[2]~13\)) # (!internal_count(3) & ((\internal_count[2]~13\) # (GND))))) # (!\Up_Down~input_o\ & ((internal_count(3) & (\internal_count[2]~13\ & VCC)) # 
-- (!internal_count(3) & (!\internal_count[2]~13\))))
-- \internal_count[3]~15\ = CARRY((\Up_Down~input_o\ & ((!\internal_count[2]~13\) # (!internal_count(3)))) # (!\Up_Down~input_o\ & (!internal_count(3) & !\internal_count[2]~13\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100100101011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \Up_Down~input_o\,
	datab => internal_count(3),
	datad => VCC,
	cin => \internal_count[2]~13\,
	combout => \internal_count[3]~14_combout\,
	cout => \internal_count[3]~15\);

-- Location: FF_X15_Y1_N21
\internal_count[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \Clock~inputclkctrl_outclk\,
	d => \internal_count[3]~14_combout\,
	clrn => \ALT_INV_Reset~inputclkctrl_outclk\,
	ena => \Enable~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => internal_count(3));

-- Location: LCCOMB_X15_Y1_N22
\internal_count[4]~16\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \internal_count[4]~16_combout\ = ((internal_count(4) $ (\Up_Down~input_o\ $ (\internal_count[3]~15\)))) # (GND)
-- \internal_count[4]~17\ = CARRY((internal_count(4) & ((!\internal_count[3]~15\) # (!\Up_Down~input_o\))) # (!internal_count(4) & (!\Up_Down~input_o\ & !\internal_count[3]~15\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000101011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => internal_count(4),
	datab => \Up_Down~input_o\,
	datad => VCC,
	cin => \internal_count[3]~15\,
	combout => \internal_count[4]~16_combout\,
	cout => \internal_count[4]~17\);

-- Location: FF_X15_Y1_N23
\internal_count[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \Clock~inputclkctrl_outclk\,
	d => \internal_count[4]~16_combout\,
	clrn => \ALT_INV_Reset~inputclkctrl_outclk\,
	ena => \Enable~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => internal_count(4));

-- Location: LCCOMB_X15_Y1_N24
\internal_count[5]~18\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \internal_count[5]~18_combout\ = (\Up_Down~input_o\ & ((internal_count(5) & (!\internal_count[4]~17\)) # (!internal_count(5) & ((\internal_count[4]~17\) # (GND))))) # (!\Up_Down~input_o\ & ((internal_count(5) & (\internal_count[4]~17\ & VCC)) # 
-- (!internal_count(5) & (!\internal_count[4]~17\))))
-- \internal_count[5]~19\ = CARRY((\Up_Down~input_o\ & ((!\internal_count[4]~17\) # (!internal_count(5)))) # (!\Up_Down~input_o\ & (!internal_count(5) & !\internal_count[4]~17\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100100101011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \Up_Down~input_o\,
	datab => internal_count(5),
	datad => VCC,
	cin => \internal_count[4]~17\,
	combout => \internal_count[5]~18_combout\,
	cout => \internal_count[5]~19\);

-- Location: FF_X15_Y1_N25
\internal_count[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \Clock~inputclkctrl_outclk\,
	d => \internal_count[5]~18_combout\,
	clrn => \ALT_INV_Reset~inputclkctrl_outclk\,
	ena => \Enable~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => internal_count(5));

-- Location: LCCOMB_X15_Y1_N26
\internal_count[6]~20\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \internal_count[6]~20_combout\ = ((internal_count(6) $ (\Up_Down~input_o\ $ (\internal_count[5]~19\)))) # (GND)
-- \internal_count[6]~21\ = CARRY((internal_count(6) & ((!\internal_count[5]~19\) # (!\Up_Down~input_o\))) # (!internal_count(6) & (!\Up_Down~input_o\ & !\internal_count[5]~19\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000101011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => internal_count(6),
	datab => \Up_Down~input_o\,
	datad => VCC,
	cin => \internal_count[5]~19\,
	combout => \internal_count[6]~20_combout\,
	cout => \internal_count[6]~21\);

-- Location: FF_X15_Y1_N27
\internal_count[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \Clock~inputclkctrl_outclk\,
	d => \internal_count[6]~20_combout\,
	clrn => \ALT_INV_Reset~inputclkctrl_outclk\,
	ena => \Enable~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => internal_count(6));

-- Location: LCCOMB_X15_Y1_N28
\internal_count[7]~22\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \internal_count[7]~22_combout\ = \Up_Down~input_o\ $ (\internal_count[6]~21\ $ (!internal_count(7)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101010100101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \Up_Down~input_o\,
	datad => internal_count(7),
	cin => \internal_count[6]~21\,
	combout => \internal_count[7]~22_combout\);

-- Location: FF_X15_Y1_N29
\internal_count[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \Clock~inputclkctrl_outclk\,
	d => \internal_count[7]~22_combout\,
	clrn => \ALT_INV_Reset~inputclkctrl_outclk\,
	ena => \Enable~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => internal_count(7));

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

ww_Count(0) <= \Count[0]~output_o\;

ww_Count(1) <= \Count[1]~output_o\;

ww_Count(2) <= \Count[2]~output_o\;

ww_Count(3) <= \Count[3]~output_o\;

ww_Count(4) <= \Count[4]~output_o\;

ww_Count(5) <= \Count[5]~output_o\;

ww_Count(6) <= \Count[6]~output_o\;

ww_Count(7) <= \Count[7]~output_o\;
END structure;


