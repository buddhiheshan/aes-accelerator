# floorplanning
# https://www.youtube.com/watch?v=jEnQemOC-O0
set DIE_WIDTH 2000
set DIE_HEIGHT 2000
set CORE_MARGIN 50
set UTILIZATION 0.70

set pspace 1
set pwidth 1
set poffset 1

set well_tap_offset 2
set well_tap_interval 2

set stripe_interval 2
set stripe_offset 2

# or do floorplane with utilization %
initCoreRow
floorPlan -site core -s $DIE_WIDTH $DIE_HEIGHT $CORE_MARGIN $CORE_MARGIN $CORE_MARGIN $CORE_MARGIN 

set wellCells [list TAPCELLBWP16P90, TAPCELLBWP16P90_VPP_VBB, TAPCELLBWP16P90_VPP_VSS, TAPCELLBWP20P90, TAPCELLBWP20P90_VPP_VBB, TAPCELLBWP20P90_VPP_VSS]
set endCaps [list BOUNDARY_PTAPBWP16P90, BOUNDARY_PTAPBWP16P90_VPP_VBB, BOUNDARY_PTAPBWP16P90_VPP_VSS, BOUNDARY_PTAPBWP20P90, BOUNDARY_PTAPBWP20P90_VPP_VBB, BOUNDARY_PTAPBWP20P90_VPP_VSS]
set fillerCells [list FILL16BWP16P90, FILL16BWP20P90, FILL1BWP16P90, FILL1BWP20P90, FILL2BWP16P90, FILL2BWP20P90, FILL32BWP16P90, FILL32BWP20P90, FILL3BWP16P90, FILL3BWP20P90, FILL4BWP16P90, FILL4BWP20P90, FILL64BWP16P90, FILL64BWP20P90, FILL8BWP16P90, FILL8BWP20P90]
set tapCell TAPCELLBWP16P90
set endCap BOUNDARY_PTAPBWP16P90

# VDD and VPP are power
# VSS and VBB are ground

# connect global net after macro placement

add_rings -nets {VDD VSS} -type core_rings -follow core -layer {top M10 bottom M10 left M11 right M11} -width {top 1 bottom 1 left 1 right 1} -spacing {top 1 bottom 1 left 1 right 1} -offset {top 1 bottom 1 left 1 right 1} -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none

set_db add_stripes_ignore_block_check false
set_db add_stripes_break_at none
set_db add_stripes_route_over_rows_only false
set_db add_stripes_rows_without_stripes_only false
set_db add_stripes_extend_to_closest_target none
set_db add_stripes_stop_at_last_wire_for_area false
set_db add_stripes_partial_set_through_domain false
set_db add_stripes_ignore_non_default_domains false
set_db add_stripes_trim_antenna_back_to_shape none
set_db add_stripes_spacing_type edge_to_edge
set_db add_stripes_spacing_from_block 0
set_db add_stripes_stripe_min_length stripe_width
set_db add_stripes_stacked_via_top_layer AP
set_db add_stripes_stacked_via_bottom_layer M1
set_db add_stripes_via_using_exact_crossover_size false
set_db add_stripes_split_vias false
set_db add_stripes_orthogonal_only true
set_db add_stripes_allow_jog { padcore_ring  block_ring }
set_db add_stripes_skip_via_on_pin {  standardcell }
set_db add_stripes_skip_via_on_wire_shape {  noshape   }

add_stripes -nets {VDD VSS} -layer M11 -direction vertical -width 1 -spacing 1 -set_to_set_distance 35 -start_from left -start_offset 35 -stop_offset 0 -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit M11 -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit M11 -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid none

place_inst u_sram/u_sram_512x45 {110.0 80.0} -fixed

set_db route_special_via_connect_to_shape { stripe }
route_special -connect core_pin -layer_change_range { M1(1) M9(11) } -block_pin_target nearest_target -core_pin_target first_after_row_end -allow_jogging 1 -crossover_via_layer_range { M1(1) M9(11) } -nets { VDD VSS } -allow_layer_change 1 -target_via_layer_range { M1(1) M9(11) }

add_well_taps -cell $tapCell -cell_interval 50.76 -in_row_offset 0 -prefix WELLTAP -checker_board

add_endcaps -start_row_cap $endCap -end_row_cap $endCap -prefix ENDCAP

connect_global_net VDD -type pgpin -pin VDD -instanceBasename *
connect_global_net VSS -type pgpin -pin VSS -instanceBasename *

connect_global_net VDD -type pgpin -pin VPP -instanceBasename *
connect_global_net VSS -type pgpin -pin VBB -instanceBasename *

connect_global_net VDD -type pgpin -pin VDDM -instanceBasename *

connect_global_net VDD -type pgpin -pin DVDD -instanceBasename *
connect_global_net VDD -type pgpin -pin AHVDD -instanceBasename *
connect_global_net VSS -type pgpin -pin DVSS -instanceBasename *
connect_global_net VSS -type pgpin -pin AHVSS -instanceBasename *

#connect power to standard cell rows through special route
#edit -> pin editor. for pins here, better to do some of them manually in the gui, with code its a bit of a hassle
