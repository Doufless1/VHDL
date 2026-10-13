# 64 x 8 single-port RAM; Quartus maps it to one M9K block. Compile-only.
#   quartus_sh -t designs/03_systems/single_port_ram/quartus/single_port_ram.tcl
#   quartus_sh --flow compile build/quartus/single_port_ram/single_port_ram
set design_dir [file dirname [file normalize [info script]]]
set project single_port_ram
set top     single_port_ram
set sources {../rtl/single_port_ram.vhd}
source [file join $design_dir .. .. .. .. scripts quartus project.tcl]
