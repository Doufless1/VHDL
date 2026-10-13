# Timing constraints for d_register (Quartus Prime Timing Analyzer)
# Clocked by a push button (single-step clock): any period is fine.
create_clock -name clk -period 100.000 [get_ports clk]
derive_clock_uncertainty
# Switches and LEDs are human-speed and asynchronous to the button clock.
set_false_path -from [get_ports {d[*] arst}]
set_false_path -to   [get_ports {q[*]}]
