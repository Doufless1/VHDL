# Timing constraints for serial_text_transmitter (Quartus Prime Timing Analyzer)
create_clock -name clk -period 20.000 [get_ports clk]   ;# 50 MHz board oscillator
derive_clock_uncertainty
# The reset button is synchronized in the RTL (sync_2ff).
set_false_path -from [get_ports reset]
# The UART line is asynchronous by definition (9600 baud).
set_false_path -to [get_ports tx]
