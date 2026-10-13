# Week-2 lab on the MAX 10 board: 3-bit ripple-carry adder (WIDTH = 3).
# Pin locations recovered from the original lab compile (Mar 2025).
#   quartus_sh -t designs/01_combinational/adders/quartus/ripple_carry_adder.tcl
#   quartus_sh --flow compile build/quartus/ripple_carry_adder/ripple_carry_adder
set design_dir [file dirname [file normalize [info script]]]
set project  ripple_carry_adder
set top      ripple_carry_adder
set sources  {../rtl/full_adder.vhd ../rtl/ripple_carry_adder.vhd}
set generics {WIDTH 3}
set pins {
    a[0]   100   a[1]   102   a[2]   112
    b[0]   118   b[1]   119   b[2]   113   cin   114
    sum[0]  55   sum[1]  47   sum[2]  46   cout   43
}
source [file join $design_dir .. .. .. .. scripts quartus project.tcl]
