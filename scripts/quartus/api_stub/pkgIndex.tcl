# Stand-in for the Quartus Tcl API, used by scripts/synth_check.py to execute the
# project scripts without Quartus (CI has no vendor tools).
package ifneeded ::quartus::project 1.0 [list source [file join $dir quartus_project_stub.tcl]]
