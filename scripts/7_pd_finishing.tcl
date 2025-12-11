set DATE [clock format [clock seconds] -format "%b%d"] 
set REPORT_DIR "physical_design/logs/report_${DATE}"
set WORSE_PARASITICS "$REPORT_DIR/picorv32_axi_worst.spef"
set BEST_PARASITICS "$REPORT_DIR/picorv32_axi_worst.spef"
set DRC_OUT "$REPORT_DIR/picorv32_axi.drc.rpt"
set CONN_OUT "$REPORT_DIR/picorv32_axi_connectivity.rpt"

set OUTPUT_DIR "physical_design/files/output_${DATE}"
set GDS_OUT "$OUTPUT_DIR/picorv32_axi.gds"
set DEF_OUT "$OUTPUT_DIR/picorv32_axi.def"
set NETLIST_OUT "$OUTPUT_DIR/picorv32_axi_signoff.v"

# verify DRC
set_db check_drc_area {0 0 0 0}
set_db check_drc_disable_rules {}
set_db check_drc_ndr_spacing auto
set_db check_drc_check_only default
set_db check_drc_inside_via_def true
set_db check_drc_exclude_pg_net false
set_db check_drc_ignore_trial_route false
set_db check_drc_ignore_cell_blockage false
set_db check_drc_use_min_spacing_on_block_obs auto
set_db check_drc_report $DRC_OUT
set_db check_drc_limit 1000
check_drc

# verify connectivity
check_connectivity -type all -geometry_connect -out_file $CONN_OUT

### Save files
extract_rc
write_parasitics -rc_corner worst_case -spef_file $WORSE_PARASITICS 

extract_rc
write_parasitics -rc_corner best_case -spef_file $BEST_PARASITICS 

set_db timing_analysis_type ocv
set_db timing_analysis_cppr both
time_design -post_route
time_design -post_route -hold

write_stream $GDS_OUT -map_file {/ip/tsmc/tsmc16adfp/tech/APR/N16ADFP_APR_Innovus/N16ADFP_APR_Innovus_Gdsout_11M.10a.map} -lib_name DesignLib -structure_name picorv32_axi -unit 2000 -mode all

write_def -floorplan -netlist -routing $DEF_OUT

write_netlist $NETLIST_OUT