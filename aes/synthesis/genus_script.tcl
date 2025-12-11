set LOCAL_DIR "[exec pwd]"

set LIB_PATH {/ip/tsmc/tsmc16adfp/stdcell/NLDM /ip/tsmc/tsmc16adfp/sram/NLDM /ip/tsmc/tsmc16adfp/stdio/NLDM /ip/tsmc/tsmc16adfp/pll/LIB}
set RTL_PATH ../rtl/
set LIBRARY {N16ADFP_StdCelltt0p8v25c.lib N16ADFP_SRAM_tt0p8v0p8v25c_100a.lib N16ADFP_StdIOtt0p8v1p8v25c.lib n16adfp_plltt0p8v1p8v25c.lib}

set FILE_LIST {
            ./pkgs/fsm4_pkg.sv 
            add_roundkey.sv 
            aes_core.sv 
            decryption_fsm.sv 
            decryption.sv 
            dff.sv 
            encryption_fsm.sv 
            encryption.sv 
            key_expansion.sv 
            mix_cols.sv 
            mux.sv 
            pipeline_reg.sv 
            s_box_inv.sv 
            s_box.sv 
            shift_rows.sv 
            sub_bytes_inv.sv 
            sub_bytes.sv 
            top_aes.sv
            }

set DESIGN {top_aes}

set SYN_EFFORT high
set MAP_EFFORT high
set OPT_EFFORT high

set SDC_FILE ../constraints/constraints.sdc

set top_module $DESIGN

set DATE [clock format [clock seconds] -format "%b%d"]

set _OUTPUTS_PATH outputs/output_${DATE}
set _LOG_PATH logs/log_${DATE}
set _REPORTS_PATH reports/report_${DATE}

set_db init_lib_search_path ${LIB_PATH} 
set_db init_hdl_search_path ${RTL_PATH}
set_db library $LIBRARY
read_libs $LIBRARY


read_hdl -sv $FILE_LIST
elaborate $DESIGN
read_sdc $SDC_FILE

set_db syn_generic_effort $SYN_EFFORT
set_db syn_map_effort $MAP_EFFORT 
set_db syn_opt_effort $OPT_EFFORT

syn_generic 
syn_map 
syn_opt 

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

#reports
report area $DESIGN > $_REPORTS_PATH/${DESIGN}_area.rpt
report datapath $DESIGN > $_REPORTS_PATH/${DESIGN}_datapath_incr.rpt
report gates $DESIGN > $_REPORTS_PATH/${DESIGN}_gates.rpt
report timing > $_REPORTS_PATH/${DESIGN}_timing.rpt
report power > $_REPORTS_PATH/${DESIGN}_power.rpt

#outputs
write_hdl > ${_OUTPUTS_PATH}/${DESIGN}_netlist.v
write_sdc > ${_OUTPUTS_PATH}/${DESIGN}_sdc.sdc
write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge -setuphold split > outputs/delay.sdf

