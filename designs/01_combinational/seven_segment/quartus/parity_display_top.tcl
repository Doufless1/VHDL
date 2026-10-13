# Hierarchy lab on the MAX 10 board: 4 switches shown in hex on the 7-segment
# display, or their parity bit. Pins from the lab compile (Mar 2025).
#   quartus_sh -t designs/01_combinational/seven_segment/quartus/parity_display_top.tcl
#   quartus_sh --flow compile build/quartus/parity_display_top/parity_display_top
set design_dir [file dirname [file normalize [info script]]]
set project parity_display_top
set top     parity_display_top
set sources {../rtl/even_parity.vhd ../rtl/seven_segment_decoder.vhd ../rtl/parity_display_top.vhd}
set pins {
    a[0]     100   a[1]     102   a[2]  112   a[3]  118   show_parity  119
    seg_n[6]  91   seg_n[5]  90   seg_n[4]  60   seg_n[3]  59
    seg_n[2]  56   seg_n[1]  96   seg_n[0]  97
}
source [file join $design_dir .. .. .. .. scripts quartus project.tcl]
