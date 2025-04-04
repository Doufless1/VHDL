onerror {exit -code 1}
vlib work
vcom -work work seven_segment_display.vho
vcom -work work output_files/Waveform3.vwf.vht
vsim  -c -t 1ps -L fiftyfivenm -L altera -L altera_mf -L 220model -L sgate -L altera_lnsim work.even_parity_checker_vhd_vec_tst
vcd file -direction seven_segment_display.msim.vcd
vcd add -internal even_parity_checker_vhd_vec_tst/*
vcd add -internal even_parity_checker_vhd_vec_tst/i1/*
proc simTimestamp {} {
    echo "Simulation time: $::now ps"
    if { [string equal running [runStatus]] } {
        after 2500 simTimestamp
    }
}
after 2500 simTimestamp
run -all
quit -f
