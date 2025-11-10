set DATE [clock format [clock seconds] -format "%b%d"] 
set OUTPUT_DIR "pnr/output_${DATE}"

set fillerCells [list FILL16BWP16P90, FILL16BWP20P90, FILL1BWP16P90, FILL1BWP20P90, FILL2BWP16P90, FILL2BWP20P90, FILL32BWP16P90, FILL32BWP20P90, FILL3BWP16P90, FILL3BWP20P90, FILL4BWP16P90, FILL4BWP20P90, FILL64BWP16P90, FILL64BWP20P90, FILL8BWP16P90, FILL8BWP20P90]

getFillerMode -quiet
addFiller -cell FILL8BWP20P90 FILL8BWP16P90 FILL64BWP20P90 FILL64BWP16P90 FILL4BWP20P90 FILL4BWP16P90 FILL3BWP20P90 FILL3BWP16P90 FILL32BWP20P90 FILL32BWP16P90 FILL2BWP20P90 FILL2BWP16P90 FILL1BWP20P90 FILL1BWP16P90 FILL16BWP20P90 FILL16BWP16P90 -prefix FILLER

# verify DRC
get_verify_drc_mode -disable_rules -quiet
get_verify_drc_mode -quiet -area
get_verify_drc_mode -quiet -layer_range
get_verify_drc_mode -check_implant -quiet
get_verify_drc_mode -check_implant_across_rows -quiet
get_verify_drc_mode -check_ndr_spacing -quiet
get_verify_drc_mode -check_only -quiet
get_verify_drc_mode -check_same_via_cell -quiet
get_verify_drc_mode -exclude_pg_net -quiet
get_verify_drc_mode -ignore_trial_route -quiet
get_verify_drc_mode -max_wrong_way_halo -quiet
get_verify_drc_mode -use_min_spacing_on_block_obs -quiet
get_verify_drc_mode -limit -quiet
set_verify_drc_mode -disable_rules {} -check_implant true -check_implant_across_rows false -check_ndr_spacing false -check_same_via_cell false -exclude_pg_net false -ignore_trial_route false -report test.drc.rpt -limit 1000
verify_drc
set_verify_drc_mode -area {0 0 0 0}

# verify connectivity
verifyConnectivity -type all -error 1000 -warning 50

### Save DEF file
set dbgLefDefOutVersion 5.8
global dbgLefDefOutVersion
set dbgLefDefOutVersion 5.8
defOut -floorplan -netlist -routing pivorv32_axi.def
set dbgLefDefOutVersion 5.8
set dbgLefDefOutVersion 5.8
