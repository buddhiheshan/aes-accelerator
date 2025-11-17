# routing

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
set_db route_detail_end_iteration 1
set_db route_with_timing_driven true
set_db route_with_si_driven true
route_design -global_detail
