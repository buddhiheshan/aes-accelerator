# floorplanning
# https://www.youtube.com/watch?v=jEnQemOC-O0
set DIE_WIDTH 2000
set DIE_HEIGHT 2000
set CORE_MARGIN 50
set UTILIZATION 0.70

set pspace 0.5
set pwidth 1
set poffset 1

floorPlan -site core -s 100 100 5 5 5 5

set wellCells [list TAPCELLBWP16P90, TAPCELLBWP16P90_VPP_VBB, TAPCELLBWP16P90_VPP_VSS, TAPCELLBWP20P90, TAPCELLBWP20P90_VPP_VBB, TAPCELLBWP20P90_VPP_VSS]
set endCaps [list BOUNDARY_PTAPBWP16P90, BOUNDARY_PTAPBWP16P90_VPP_VBB, BOUNDARY_PTAPBWP16P90_VPP_VSS, BOUNDARY_PTAPBWP20P90, BOUNDARY_PTAPBWP20P90_VPP_VBB, BOUNDARY_PTAPBWP20P90_VPP_VSS]
set fillerCells [list FILL16BWP16P90, FILL16BWP20P90, FILL1BWP16P90, FILL1BWP20P90, FILL2BWP16P90, FILL2BWP20P90, FILL32BWP16P90, FILL32BWP20P90, FILL3BWP16P90, FILL3BWP20P90, FILL4BWP16P90, FILL4BWP20P90, FILL64BWP16P90, FILL64BWP20P90, FILL8BWP16P90, FILL8BWP20P90]

setAddRingMode -stacked_via_top_layer M3 -stacked_via_bottom_layer M1
addIoFiller -cell FILL16BWP16P90 -prefix FILLER -side n -fillAnyGap
addRing -nets { VDD VDDM VSS } -type core_rings -around user_defined -center 0 -spacing $pspace -width $pwidth -offset $poffset -threshold auto -layer {bottom M1 top M1 right M2 left M2 }
addWellTap -cell TAPCELLBWP16P90 -cellInterval 15 -inRowOffset 15 -prefix WELLTAP
addEndCap -preCap BOUNDARY_PTAPBWP16P90 -postCap BOUNDARY_PTAPBWP16P90 -prefix ENDCAP
addStripe -nets {VDD VDDM VSS} -layer M3 -width $pwidth -spacing $pspace -set_to_set_distance 25 -start_from left -start_offset 25 -switch_layer_over_obs false -max_same_layer_jog_length 2 -padcore_ring_top_layer_limit AP -padcore_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid None


#edit pins here, better to do some of them manually in the gui, with code its a bit of a hassle
