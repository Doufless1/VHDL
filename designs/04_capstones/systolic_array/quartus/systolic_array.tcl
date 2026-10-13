# 4x4 INT8 systolic array as an IP block: 16 MACs map onto the MAX 10's
# embedded multipliers. Compile-only: the 576 bits of operand/result buses
# stay on-chip (virtual pins) so only the core is timed.
#   quartus_sh -t designs/04_capstones/systolic_array/quartus/systolic_array.tcl
#   quartus_sh --flow compile build/quartus/systolic_array/systolic_array
set design_dir [file dirname [file normalize [info script]]]
set project      systolic_array
set top          systolic_array
set sources      {../rtl/mac_pe.vhd ../rtl/systolic_array.vhd}
set generics     {ROWS 4 COLS 4}
set virtual_pins {rst in_valid in_ready in_last a_col[*] b_row[*] out_valid c_mat[*]}
source [file join $design_dir .. .. .. .. scripts quartus project.tcl]
