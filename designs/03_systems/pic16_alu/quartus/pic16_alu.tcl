# PIC16 execute stage (combinational). Compile-only.
#   quartus_sh -t designs/03_systems/pic16_alu/quartus/pic16_alu.tcl
#   quartus_sh --flow compile build/quartus/pic16_alu/pic16_alu
set design_dir [file dirname [file normalize [info script]]]
set project pic16_alu
set top     pic16_alu
set sources {../rtl/pic16_alu.vhd}
source [file join $design_dir .. .. .. .. scripts quartus project.tcl]
