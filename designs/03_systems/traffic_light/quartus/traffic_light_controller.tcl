# Pedestrian-crossing controller, default timing for the 50 MHz board clock.
# Compile-only (the lab build used automatic pin placement).
#   quartus_sh -t designs/03_systems/traffic_light/quartus/traffic_light_controller.tcl
#   quartus_sh --flow compile build/quartus/traffic_light_controller/traffic_light_controller
set design_dir [file dirname [file normalize [info script]]]
set project traffic_light_controller
set top     traffic_light_controller
set sources {../../../00_common/rtl/sync_2ff.vhd ../rtl/traffic_light_controller.vhd}
source [file join $design_dir .. .. .. .. scripts quartus project.tcl]
