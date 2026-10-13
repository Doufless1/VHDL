# -----------------------------------------------------------------------------
# Shared Intel Quartus Prime project setup for the MAX 10 lab board.
#
# Every designs/<category>/<design>/quartus/<project>.tcl sets these variables
# and then sources this file:
#
#   design_dir    directory of the calling script (for relative paths)
#   project       project name; <project>.sdc next to the script is used
#   top           top-level entity
#   sources       VHDL files, relative to design_dir, in dependency order
#   generics      (optional) {name value ...} top-level generic overrides
#   pins          (optional) {port pin ...} board pin locations
#   virtual_pins  (optional) ports kept on-chip, for compile-only IP blocks
#
# The project is generated out of tree, in build/quartus/<project>/, so tool
# output never mixes with sources. Usage, from any directory:
#
#   quartus_sh -t designs/.../quartus/<project>.tcl
#   quartus_sh --flow compile build/quartus/<project>/<project>
# -----------------------------------------------------------------------------
package require ::quartus::project

set repo_root [file normalize [file join [file dirname [info script]] .. ..]]
set build_dir [file join $repo_root build quartus $project]
file mkdir $build_dir
cd $build_dir

project_new $project -overwrite

# Device on the lab board (as used for the 2025 lab compiles)
set_global_assignment -name FAMILY "MAX 10"
set_global_assignment -name DEVICE 10M08SAE144C8GES
set_global_assignment -name TOP_LEVEL_ENTITY $top
set_global_assignment -name VHDL_INPUT_VERSION VHDL_1993
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
set_global_assignment -name SYNCHRONIZER_IDENTIFICATION AUTO

foreach src $sources {
    set_global_assignment -name VHDL_FILE [file normalize [file join $design_dir $src]]
}

set sdc [file join $design_dir $project.sdc]
if {[file exists $sdc]} {
    set_global_assignment -name SDC_FILE $sdc
}

if {[info exists generics]} {
    foreach {name value} $generics {
        set_parameter -name $name $value
    }
}

if {[info exists pins]} {
    foreach {port pin} $pins {
        set_location_assignment PIN_$pin -to $port
        set_instance_assignment -name IO_STANDARD "2.5 V" -to $port
    }
}

if {[info exists virtual_pins]} {
    foreach port $virtual_pins {
        set_instance_assignment -name VIRTUAL_PIN ON -to $port
    }
}

export_assignments
project_close
post_message "Created $build_dir/$project.qpf"
