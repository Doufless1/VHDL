# Flip-flop lab on the MAX 10 board: 6-bit register (the board has 6 free
# switches/LEDs), clocked by a push button. Pins from the lab compile.
#   quartus_sh -t designs/02_sequential/d_register/quartus/d_register.tcl
#   quartus_sh --flow compile build/quartus/d_register/d_register
set design_dir [file dirname [file normalize [info script]]]
set project  d_register
set top      d_register
set sources  {../rtl/d_register.vhd}
set generics {WIDTH 6}
set pins {
    clk   98    arst 114
    d[0] 100    d[1] 102    d[2] 112    d[3] 118    d[4] 119    d[5] 113
    q[0]  55    q[1]  47    q[2]  46    q[3]  43    q[4]  41    q[5]  33
}
source [file join $design_dir .. .. .. .. scripts quartus project.tcl]
