# Innovus 
# *************************************************
# * Local Variable settings for this design
# *************************************************
# * Resources 
# https://www.eng.auburn.edu/~nelson/courses/elec5250_6250/slides/ASIC%20Layout_2%20%20Digital%20Innovus.pdf
# https://digitalsystemdesign.in/pnr-using-innovus-with-scripts/?srsltid=AfmBOoqQYtWIMKeGR4eVudM1Hvt4_MMq7aKaDRwz9VsDofwGRokgGEPk
# *************************************************

set LOCAL_DIR "[exec pwd]"
set SYNTH_DIR $LOCAL_DIR
set RTL_PATH $LOCAL_DIR/picorv32
set FILE_LIST  {picorv32.v}
set DESIGN       {picorv32_axi}

set DATE [clock format [clock seconds] -format "%b%d"] 
set NETLIST_FILE $LOCAL_DIR/syn/outputs/${DESIGN}.v
set SDC_FILE $LOCAL_DIR/syn/outputs/${DESIGN}.sdc
set OUTPUT_DIR "fp/output_${DATE}"
set LIBRARY_LEF_FILES [list "/ip/tsmc/tsmc16adfp/stdcell/LEF/lef/N16ADFP_StdCell.lef" "/ip/tsmc/tsmc16adfp/sram/LEF/N16ADFP_SRAM_100a.lef"]
set TIMING_LIB_FILES [list "/ip/tsmc/tsmc16adfp/stdcell/CCS/N16ADFP_StdCellss0p72v125c_ccs.lib" "/ip/tsmc/tsmc16adfp/sram/NLDM/N16ADFP_SRAM_ss0p72v0p72v125c_100a.lib"]

puts "INFO: Loading Libraries..."

set_db init_lef_files $LIBRARY_LEF_FILES
set_db init_lib_search_path $TIMING_LIB_FILES

create_library_set -name TYPlib -timing $TIMING_LIB_FILES
create_constraint_mode -name CONSTR_MODE -sdc_files $SDC_FILE


if { ![file exists $OUTPUT_DIR] } {
    file mkdir $OUTPUT_DIR
}


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
