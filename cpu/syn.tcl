# Genus
# *************************************************
# * Local Variable settings for this design
# *************************************************
set LOCAL_DIR "[exec pwd]"
set SYNTH_DIR $LOCAL_DIR
set RTL_PATH $LOCAL_DIR/picorv32
set LIB_PATH {/ip/tsmc/tsmc16adfp/stdcell/CCS}
set FILE_LIST  {picorv32.v}
set SYN_EFFORT   high
set MAP_EFFORT   high
set DESIGN       {picorv32_axi}
set SDC_FILE design_constraints.sdc
set THE_DATE  [exec date +%m%d.%H%M]

set top_module $DESIGN
set SYN_EFF high
set MAP_EFF high
set DATE [clock format [clock seconds] -format "%b%d"] 

set _OUTPUTS_PATH syn/outputs/output_${DATE}
set _LOG_PATH syn/logs/log_${DATE}
set _REPORTS_PATH syn/reports/report_${DATE}

set_db information_level 7 
set_db init_lib_search_path ${LIB_PATH} 
set_db init_hdl_search_path ${RTL_PATH} 
set_db library $LIBRARY

read_hdl $FILE_LIST
elaborate $DESIGN
check_design $DESIGN -unresolved

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

set_db syn_generic_effort medium
set_db syn_map_effort medium 
set_db syn_opt_effort medium

syn_generic 
syn_map 
syn_opt 


report area $DESIGN > $_REPORTS_PATH/${DESIGN}_area.rpt
report datapath $DESIGN > $_REPORTS_PATH/${DESIGN}_datapath_incr.rpt
report gates $DESIGN > $_REPORTS_PATH/${DESIGN}_gates.rpt
write_design -basename ${_OUTPUTS_PATH}/${DESIGN}
write_hdl > ${_OUTPUTS_PATH}/${DESIGN}.v
write_sdc > ${_OUTPUTS_PATH}/${DESIGN}.sdc
write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge -setuphold split > outputs/delay.sdf
