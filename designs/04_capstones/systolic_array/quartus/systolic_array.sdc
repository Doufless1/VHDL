# Timing constraints for systolic_array (Quartus Prime Timing Analyzer)
create_clock -name clk -period 20.000 [get_ports clk]   ;# 50 MHz board oscillator
derive_clock_uncertainty
