# Genus - synthesis
set SYNTH_DIR synthesis
set RTL_PATH {TOP-sram-cpu/rtl TOP-sram-cpu/rtl/tb /ip/tsmc/tsmc16adfp/sram/VERILOG aes/rtl aes/rtl/pkgs}
set FILE_LIST  {system_top.v sram_axi_wrapper.v picorv32.v N16ADFP_SRAM_100a.v fsm4_pkg.sv top_aes.sv aes_core.sv add_roundkey.sv decryption.sv decryption_fsm.sv dff.sv encryption.sv encryption_fsm.sv key_expansion.sv mux_cols.sv pipeline_reg.sv s_box.sv s_box_inv.sv shift_rows.sv sub_bytes.sv sub_bytes_inv.sv}
set DESIGN       {system_top}
#set RTL_PATH $LOCAL_DIR/example
#set FILE_LIST {example.v}
#set DESIGN {mux4to1}
set LIB_PATH {/ip/tsmc/tsmc16adfp/stdcell/NLDM /ip/tsmc/tsmc16adfp/sram/NLDM /ip/tsmc/tsmc16adfp/stdio/NLDM /ip/tsmc/tsmc16adfp/pll/LIB}
set SYN_EFFORT   high
set MAP_EFFORT   high
set OPT_EFFORT high
set SDC_FILE constraints/design_constraints.sdc
set THE_DATE  [exec date +%m%d.%H%M]
set LIBRARY {N16ADFP_StdCelltt0p8v25c.lib N16ADFP_SRAM_tt0p8v0p8v25c_100a.lib N16ADFP_StdIOtt0p8v1p8v25c.lib n16adfp_plltt0p8v1p8v25c.lib}

#set_library_set tt_libset  {N16ADFP_StdCelltt0p8v25c.lib N16ADFP_SRAM_tt0p8v0p8v25c_100a.lib N16ADFP_StdIOtt0p8v1p8v25c.lib n16adfp_plltt0p8v1p8v25c.lib}
#set_operating_conditions -max tt_libset

#set_library_set ff_libset {N16ADFP_StdCellff0p88vm40c.lib N16ADFP_SRAM_ff0p88v0p88vm40c_100a.lib N16ADFP_StdIOff0p88v1p98vm40c.lib n16adfp_pllff0p88v1p98vm40c.lib}
#set_operating_conditions -min ff_libset

set top_module $DESIGN
set DATE [clock format [clock seconds] -format "%b%d"] 

set _OUTPUTS_PATH $SYNTH_DIR/files/output_${DATE}
set _LOG_PATH $SYNTH_DIR/logs/log_${DATE}
set _REPORTS_PATH $SYNTH_DIR/logs/report_${DATE}

set_db information_level 7 
set_db init_lib_search_path ${LIB_PATH} 
set_db init_hdl_search_path ${RTL_PATH} 
set_db library $LIBRARY
read_libs $LIBRARY

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

set_db syn_generic_effort $SYN_EFFORT
set_db syn_map_effort $MAP_EFFORT 
set_db syn_opt_effort $OPT_EFFORT

syn_generic 
syn_map 
syn_opt 

report area $DESIGN > $_REPORTS_PATH/${DESIGN}_area.rpt
report datapath $DESIGN > $_REPORTS_PATH/${DESIGN}_datapath_incr.rpt
report gates $DESIGN > $_REPORTS_PATH/${DESIGN}_gates.rpt
report timing > $_REPORTS_PATH/${DESIGN}_timing.rpt
report power > $_REPORTS_PATH/${DESIGN}_power.rpt

write_hdl > ${_OUTPUTS_PATH}/${DESIGN}.v
write_sdc > ${_OUTPUTS_PATH}/${DESIGN}.sdc
write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge -setuphold split > outputs/delay.sdf