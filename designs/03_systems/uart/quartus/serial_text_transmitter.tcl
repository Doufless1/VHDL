# Final assignment: "HELLO!" at 9600 baud from the 50 MHz board clock.
# Connect tx to the RX pin of a 3.3 V USB-serial adapter (and GND).
#   quartus_sh -t designs/03_systems/uart/quartus/serial_text_transmitter.tcl
#   quartus_sh --flow compile build/quartus/serial_text_transmitter/serial_text_transmitter
set design_dir [file dirname [file normalize [info script]]]
set project serial_text_transmitter
set top     serial_text_transmitter
set sources {../../../00_common/rtl/sync_2ff.vhd ../rtl/uart_tx.vhd ../rtl/serial_text_transmitter.vhd}
source [file join $design_dir .. .. .. .. scripts quartus project.tcl]
