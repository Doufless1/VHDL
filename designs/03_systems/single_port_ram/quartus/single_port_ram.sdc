# Timing constraints for single_port_ram (Quartus Prime Timing Analyzer)
create_clock -name clk -period 20.000 [get_ports clk]   ;# 50 MHz board oscillator
derive_clock_uncertainty
set_input_delay  -clock clk 0.000 [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay -clock clk 0.000 [all_outputs]
