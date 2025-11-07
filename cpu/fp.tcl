# Innovus 
set NETLIST_FILE "../syn/outputs/${DESIGN}.v"
set SDC_FILE "../syn/outputs/${DESIGN}.sdc"
set OUTPUT_DIR "fp/output_${DATE}"
set LIBRARY_LEF_FILES [list "/ip/tsmc/tsmc16adfp/stdcell/LEF/lef/N16ADFP_StdCell.lef" "/ip/tsmc/tsmc16adfp/sram/LEF/N16ADFP_SRAM_100a.lef"]
set TIMING_LIB_FILES [list "/ip/tsmc/tsmc16adfp/stdcell/CCS/N16ADFP_StdCellss0p72v125c_ccs.lib" "/ip/tsmc/tsmc16adfp/sram/NLDM/N16ADFP_SRAM_ss0p72v0p72v125c_100a.lib"]
set TECH_FILE "/ip/tsmc/tsmc16adfp/tech/APR/N16ADFP_APR_ICC2/N16ADFP_APR_ICC2_11M.10a.tf"
set LIBRARY  {N16ADFP_StdCellss0p72v125c_ccs.lib}

if { ![file exists $OUTPUT_DIR] } {
    file mkdir $OUTPUT_DIR
}

puts "INFO: Loading Libraries..."
set_db tech_file $TECH_FILE
set_db lef_files $LIBRARY_LEF_FILES
set_db timing_library $TIMING_LIB_FILES 

puts "INFO: Starting design initialization..."
init_design -netlist $NETLIST_FILE -top $DESIGN -overwrite
read_sdc $SDC_FILE
check_design

puts "INFO: Creating Floorplan..."

set DIE_WIDTH 1000
set DIE_HEIGHT 1000
set CORE_MARGIN 50
set UTILIZATION 0.70

set_db plan_cfg -target_utilization $UTILIZATION

floorplan \
    -d { $DIE_WIDTH $DIE_HEIGHT } \
    -r { $CORE_MARGIN $CORE_MARGIN $CORE_MARGIN $CORE_MARGIN }

puts "INFO: Creating primary power rings."
add_ring \
    -layer {M5 M6} \
    -width {10 10} \
    -spacing {5 5} \
    -offset {5 5} \
    -nets {VDD VSS}

add_stripe \
    -layer M4 \
    -width 5 \
    -spacing 50 \
    -route_boundary {0 0 900 900} \
    -nets {VDD VSS} \
    -direction vertical

puts "INFO: Launching GUI for visualization. Close the GUI window to proceed."
win 


puts "INFO: Saving floorplan design state to ${OUTPUT_DIR}/floorplan.enc.dat"
saveDesign ${OUTPUT_DIR}/floorplan.enc
