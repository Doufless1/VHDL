# Multiplexer lab on the MAX 10 board: the 1-to-4 demultiplexer (top level
# of the original "mux_4to1" project). Pins from the lab compile (Mar 2025).
#   quartus_sh -t designs/01_combinational/data_routing/quartus/demux_1to4.tcl
#   quartus_sh --flow compile build/quartus/demux_1to4/demux_1to4
set design_dir [file dirname [file normalize [info script]]]
set project demux_1to4
set top     demux_1to4
set sources {../rtl/demux_1to4.vhd}
set pins {
    d     100   s[1]  102   s[0]  112
    y0     55   y1     47   y2     46   y3  43
}
source [file join $design_dir .. .. .. .. scripts quartus project.tcl]
