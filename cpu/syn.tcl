set DESIGN  $DESIGN 
set top_module $DESIGN
set SYN_EFF high
set MAP_EFF high
set DATE [clock format [clock seconds] -format "%b%d"] 

set _OUTPUTS_PATH /outputs/output_${DATE}
set _LOG_PATH /logs/log_${DATE}
set _REPORTS_PATH /reports/report_${DATE}
set_db information_level 7 

set_db init_lib_search_path ${LIB_PATH} 
set_db init_hdl_search_path ${RTL_PATH} 
set_db library $LIBRARY


read_hdl $FILE_LIST
elaborate $DESIGN
check_design -unresolved

read_sdc $SDC_FILE


if {![file exists ${_LOG_PATH}]} {
  file mkdir ${_LOG_PATH}
  puts "Creating directory ${_LOG_PATH}"
}
if {![file exists ${_OUTPUTS_PATH}]} {
  file mkdir ${_OUTPUTS_PATH}
  puts "Creating directory ${_OUTPUTS_PATH}"
}
if {![file exists ${_REPORTS_PATH}]} {
  file mkdir ${_REPORTS_PATH}
  puts "Creating directory ${_REPORTS_PATH}"
}
report timing -lint


set_db syn_generic_effort medium
set_db syn_map_effort medium 
set_db syn_opt_effort medium

syn_generic 
syn_map 
syn_opt 


report area > $_REPORTS_PATH/${DESIGN}_area.rpt
report datapath > $_REPORTS_PATH/${DESIGN}_datapath_incr.rpt
report gates > $_REPORTS_PATH/${DESIGN}_gates.rpt
write_design -basename ${_OUTPUTS_PATH}/${DESIGN}
write_hdl  > ${_OUTPUTS_PATH}/${DESIGN}.v
write_script > ${_OUTPUTS_PATH}/${DESIGN}.script
write_sdc > ${_OUTPUTS_PATH}/${DESIGN}.sdc
write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge -setuphold split > outputs/delay.sdf
