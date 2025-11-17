set DATE [clock format [clock seconds] -format "%b%d"] 
set OUTPUT_DIR "pnr/output_${DATE}"
set WORSE_PARASITICS "$OUTPUT_DIR/mux4to1_worst.spef"
set BEST_PARASITICS "$OUTPUT_DIR/mux4to1_worst.spef"
set GDS_OUT "$OUTPUT_DIR/mux4to1"
set DEF_OUT "$OUTPUT_DIR/mux4to1.def"

set fillerCells [list FILL16BWP16P90, FILL16BWP20P90, FILL1BWP16P90, FILL1BWP20P90, FILL2BWP16P90, FILL2BWP20P90, FILL32BWP16P90, FILL32BWP20P90, FILL3BWP16P90, FILL3BWP20P90, FILL4BWP16P90, FILL4BWP20P90, FILL64BWP16P90, FILL64BWP20P90, FILL8BWP16P90, FILL8BWP20P90]

getFillerMode -quiet
add_fillers -base_cells FILL8BWP20P90 FILL8BWP16P90 FILL64BWP20P90 FILL64BWP16P90 FILL4BWP20P90 FILL4BWP16P90 FILL3BWP20P90 FILL3BWP16P90 FILL32BWP20P90 FILL32BWP16P90 FILL2BWP20P90 FILL2BWP16P90 FILL1BWP20P90 FILL1BWP16P90 FILL16BWP20P90 FILL16BWP16P90 -prefix FILLER

# verify DRC
set_db check_drc_disable_rules {}
set_db check_drc_ndr_spacing auto
set_db check_drc_check_only default
set_db check_drc_inside_via_def true
set_db check_drc_exclude_pg_net false
set_db check_drc_ignore_trial_route false
set_db check_drc_ignore_cell_blockage false
set_db check_drc_use_min_spacing_on_block_obs auto
set_db check_drc_limit 1000
check_drc

# verify connectivity
check_connectivity -type all -geometry_connect -error 1000 -warning 50

### Save files
write_parasitics -spef_file $WORSE_PARASITICS -rc_corner worst_case

write_parasitics -spef_file $BEST_PARASITICS -rc_corner best_case

write_stream $GDS_OUT -lib_name DesignLib -unit 2000 -mode all

write_def -floorplan -netlist -routing DEF_OUT
