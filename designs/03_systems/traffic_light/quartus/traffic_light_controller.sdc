# Timing constraints for traffic_light_controller (Quartus Prime Timing Analyzer)
create_clock -name clk -period 20.000 [get_ports clk]   ;# 50 MHz board oscillator
derive_clock_uncertainty
# Push button: synchronized in the RTL (sync_2ff). The lab reset is a raw
# asynchronous input; its release is not timed (see serial_text_transmitter
# for a synchronized reset).
set_false_path -from [get_ports {arst pedestrian_btn}]
# Lamps are human-speed outputs.
set_false_path -to [get_ports {car_* ped_*}]
