# floorplanning
# https://www.youtube.com/watch?v=jEnQemOC-O0
set DIE_WIDTH 2000
set DIE_HEIGHT 2000
set CORE_MARGIN 50
set UTILIZATION 0.70

set pspace 1
set pwidth 1.25
set poffset 1

# or do floorplane with utilization %
floorPlan -site core -s 100 100 10 10 10 10

set wellCells [list TAPCELLBWP16P90, TAPCELLBWP16P90_VPP_VBB, TAPCELLBWP16P90_VPP_VSS, TAPCELLBWP20P90, TAPCELLBWP20P90_VPP_VBB, TAPCELLBWP20P90_VPP_VSS]
set endCaps [list BOUNDARY_PTAPBWP16P90, BOUNDARY_PTAPBWP16P90_VPP_VBB, BOUNDARY_PTAPBWP16P90_VPP_VSS, BOUNDARY_PTAPBWP20P90, BOUNDARY_PTAPBWP20P90_VPP_VBB, BOUNDARY_PTAPBWP20P90_VPP_VSS]
set fillerCells [list FILL16BWP16P90, FILL16BWP20P90, FILL1BWP16P90, FILL1BWP20P90, FILL2BWP16P90, FILL2BWP20P90, FILL32BWP16P90, FILL32BWP20P90, FILL3BWP16P90, FILL3BWP20P90, FILL4BWP16P90, FILL4BWP20P90, FILL64BWP16P90, FILL64BWP20P90, FILL8BWP16P90, FILL8BWP20P90]

# VDD and VPP are power
# VSS and VBB are ground

globalNetConnect VDD -type pgpin -pin VDD -instanceBasename *
globalNetConnect VSS -type pgpin -pin VSS -instanceBasename *
globalNetConnect VPP -type pgpin -pin VPP -instanceBasename *
globalNetConnect VBB -type pgpin -pin VBB -instanceBasename *

setAddRingMode -stacked_via_top_layer M3 -stacked_via_bottom_layer M1
#addIoFiller -cell FILL16BWP16P90 -prefix FILLER -side n -fillAnyGap
addRing -nets { VDD VSS VPP VBB } -type core_rings -around user_defined -center 0 -spacing $pspace -width $pwidth -offset $poffset -threshold auto -layer {bottom M1 top M1 right M2 left M2 }
addWellTap -cell TAPCELLBWP16P90 -cellInterval 12.5 -inRowOffset 6.25 -prefix WELLTAP
addEndCap -preCap BOUNDARY_PTAPBWP16P90 -postCap BOUNDARY_PTAPBWP16P90 -prefix ENDCAP
addStripe -nets {VDD VSS VPP VBB} -layer M3 -width $pwidth -spacing $pspace -set_to_set_distance 25 -start_from left -start_offset 25 -switch_layer_over_obs false -max_same_layer_jog_length 2 -padcore_ring_top_layer_limit AP -padcore_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid None

#connect power to standard cell rows through special route
#edit pins here, better to do some of them manually in the gui, with code its a bit of a hassle
