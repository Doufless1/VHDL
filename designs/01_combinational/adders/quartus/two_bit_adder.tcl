# Week-1 lab on the MAX 10 board: two 2-bit numbers on switches, sum on LEDs.
# Pin locations recovered from the original lab compile (Feb 2025).
#   quartus_sh -t designs/01_combinational/adders/quartus/two_bit_adder.tcl
#   quartus_sh --flow compile build/quartus/two_bit_adder/two_bit_adder
set design_dir [file dirname [file normalize [info script]]]
set project two_bit_adder
set top     two_bit_adder
set sources {../rtl/two_bit_adder.vhd}
set pins {
    a0    100    a1    102
    b0    112    b1    118
    sum0   47    sum1   46    carry  55
}
source [file join $design_dir .. .. .. .. scripts quartus project.tcl]
