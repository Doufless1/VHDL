# Minimal stand-in for Quartus' ::quartus::project package. Each command prints
# what Quartus would record; source and constraint files must exist.
package provide ::quartus::project 1.0

proc project_new {name args}         { puts "project_new $name $args" }
proc set_location_assignment {args}  { puts "set_location_assignment $args" }
proc set_instance_assignment {args}  { puts "set_instance_assignment $args" }
proc set_parameter {args}            { puts "set_parameter $args" }
proc export_assignments {}           {}
proc project_close {}                {}
proc post_message {msg}              { puts $msg }

proc set_global_assignment {args} {
    puts "set_global_assignment $args"
    set kind [lindex $args [expr {[lsearch $args -name] + 1}]]
    set value [lindex $args end]
    if {$kind in {VHDL_FILE SDC_FILE} && ![file exists $value]} {
        error "missing file: $value"
    }
}
