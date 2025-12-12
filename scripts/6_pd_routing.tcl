# routing & fillers if needed
set DATE [clock format [clock seconds] -format "%b%d"] 
set REPORT_DIR "physical_design/logs/report_${DATE}"

# this script takes forever, so go get food or go to the gym while it runs

set_db route_detail_fix_antenna 1
set_db route_antenna_diode_insertion 0
set_db route_with_timing_driven 1
set_db route_with_eco 0
set_db route_with_litho_driven 0
set_db route_detail_post_route_litho_repair 0
set_db route_with_si_driven 1
set_db route_detail_auto_stop 0
set_db route_selected_net_only 0
set_db design_top_routing_layer 9
set_db design_bottom_routing_layer 1
set_db route_detail_end_iteration 10
set_db route_with_timing_driven true
set_db route_with_si_driven true
route_design -global_detail

set fillerCells [list FILL16BWP16P90, FILL16BWP20P90, FILL1BWP16P90, FILL1BWP20P90, FILL2BWP16P90, FILL2BWP20P90, FILL32BWP16P90, FILL32BWP20P90, FILL3BWP16P90, FILL3BWP20P90, FILL4BWP16P90, FILL4BWP20P90, FILL64BWP16P90, FILL64BWP20P90, FILL8BWP16P90, FILL8BWP20P90]

opt_design -post_route -report_dir $REPORT_DIR
opt_design -post_route -hold -report_dir $REPORT_DIR
opt_design -post_route -hold -setup -report_dir $REPORT_DIR

set_db timing_analysis_type ocv
set_db timing_analysis_cppr both
time_design -post_route
time_design -post_route -hold

#getFillerMode -quiet
add_fillers -base_cells $fillerCells -prefix FILLER
