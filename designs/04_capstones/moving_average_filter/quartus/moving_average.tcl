# Moving-average filter as an IP block (12-bit samples, 8 taps). Compile-only:
# the streaming ports stay on-chip (virtual pins) so only the core is timed.
#   quartus_sh -t designs/04_capstones/moving_average_filter/quartus/moving_average.tcl
#   quartus_sh --flow compile build/quartus/moving_average/moving_average
set design_dir [file dirname [file normalize [info script]]]
set project      moving_average
set top          moving_average
set sources      {../rtl/moving_average.vhd}
set virtual_pins {rst s_valid s_data[*] m_valid m_data[*]}
source [file join $design_dir .. .. .. .. scripts quartus project.tcl]
