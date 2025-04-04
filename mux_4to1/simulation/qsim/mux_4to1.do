onerror {exit -code 1}
vlib work
vcom -work work mux_4to1.vho
vcom -work work output_files/Waveform.vwf.vht
vsim -c -t 1ps -L fiftyfivenm -L altera -L altera_mf -L 220model -L sgate -L altera_lnsim work.demux_1to4_vhd_vec_tst
vcd file -direction mux_4to1.msim.vcd
vcd add -internal demux_1to4_vhd_vec_tst/*
vcd add -internal demux_1to4_vhd_vec_tst/i1/*
proc simTimestamp {} {
    echo "Simulation time: $::now ps"
    if { [string equal running [runStatus]] } {
        after 2500 simTimestamp
    }
}
after 2500 simTimestamp
run -all
quit -f
