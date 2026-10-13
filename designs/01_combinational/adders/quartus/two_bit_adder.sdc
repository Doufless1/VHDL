# Timing constraints for two_bit_adder (Quartus Prime Timing Analyzer)
# Purely combinational: switches -> logic -> LEDs. With no clock in the
# design, a virtual clock gives the Timing Analyzer a pin-to-pin budget.
create_clock -name virtual_clk -period 20.000
set_input_delay  -clock virtual_clk 0.000 [all_inputs]
set_output_delay -clock virtual_clk 0.000 [all_outputs]
