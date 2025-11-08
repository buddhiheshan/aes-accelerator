# Innovus 
# *************************************************
# * Local Variable settings for this design
# *************************************************
# * Resources 
# https://www.eng.auburn.edu/~nelson/courses/elec5250_6250/slides/ASIC%20Layout_2%20%20Digital%20Innovus.pdf
# https://digitalsystemdesign.in/pnr-using-innovus-with-scripts/?srsltid=AfmBOoqQYtWIMKeGR4eVudM1Hvt4_MMq7aKaDRwz9VsDofwGRokgGEPk
# https://limsk.ece.gatech.edu/course/ece6133/lab/innovus.pdf using the gui
# https://www.youtube.com/watch?v=jEnQemOC-O0 videos with scripts
# *************************************************

set DATE [clock format [clock seconds] -format "%b%d"] 
set NETLIST_FILE $LOCAL_DIR/syn/outputs/${DESIGN}.v
set SDC_FILE $LOCAL_DIR/syn/outputs/${DESIGN}.sdc
set OUTPUT_DIR "pnr/output_${DATE}"
set LIBRARY_LEF_FILES [list "/ip/tsmc/tsmc16adfp/stdcell/LEF/lef/N16ADFP_StdCell.lef" "/ip/tsmc/tsmc16adfp/sram/LEF/N16ADFP_SRAM_100a.lef"]
set TIMING_LIB_MIN [list "/ip/tsmc/tsmc16adfp/stdcell/CCS/N16ADFP_StdCellff0p88vm40c_ccs.lib" "/ip/tsmc/tsmc16adfp/sram/NLDM/N16ADFP_SRAM_ff0p72v0p88vm40c_100a.lib"]
set TIMING_LIB_MAX [list "/ip/tsmc/tsmc16adfp/stdcell/CCS/N16ADFP_StdCellss0p72v125c_ccs.lib" "/ip/tsmc/tsmc16adfp/sram/NLDM/N16ADFP_SRAM_ss0p72v0p72v125c_100a.lib"]

puts "INFO: Loading Libraries..."

set init_lef_file {/ip/tsmc/tsmc16adfp/tech/APR/N16ADFP_APR_Innovus/N16ADFP_APR_Innovus_11M.10a.tlef /ip/tsmc/tsmc16adfp/pll/LEF/lef/n16adfp_pll_100a_10lm.lef /ip/tsmc/tsmc16adfp/stdcell/LEF/lef/N16ADFP_StdCell.lef /ip/tsmc/tsmc16adfp/sram/LEF/N16ADFP_SRAM_100a.lef /ip/tsmc/tsmc16adfp/stdio/LEF/N16ADFP_StdIO.lef}
set init_original_verilog_files ../syn/outputs/picorv32_axi.v
set init_verilog ../syn/outputs/picorv32_axi.v

create_library_set -name MINLib -timing $TIMING_LIB_MIN
create_library_set -name MAXLib -timing $TIMING_LIB_MAX
create_constraint_mode -name CONSTR_MODE -sdc_files $SDC_FILE

create_rc_corner -name rc_worst -T 25 
create_delay_corner -name delay_corner_max -library_set MAXLib -rc_corner rc_worst
create_delay_corner -name delay_corner_min -library_set MINLib -rc_corner rc_worst
create_analsis_view -name analysis_view_setup -constraint_mode CONSTR_MODE -delay_corner my_delay_corner_max
create_analysis_view -name analysis_view_hold -constraint_mode CONSTR_MODE -delay_corner delay_corner_min

set_analysis_view -setup [list analysis_view_setup] -hold [list analysis_view_hold]

set init_gnd_nets [list "VDD" "VDDM"]
set init_pwr_nets [list "VSS" ]

set DIE_WIDTH 2000
set DIE_HEIGHT 2000
set CORE_MARGIN 50
set UTILIZATION 0.70

init_design'
floorPlan -site CoreSite -d $DIE_WIDTH $DIE_HEIGHT $CORE_MARGIN $CORE_MARGIN $CORE_MARGIN $CORE_MARGIN
addIoFiller -cell pfeed10000 -prefix FILLER -side n
addIoFiller -cell pfeed10000 -prefix FILLER -side e
addIoFiller -cell pfeed10000 -prefix FILLER -side s
addIoFiller -cell pfeed10000 -prefix FILLER -side w


if { ![file exists $OUTPUT_DIR] } {
    file mkdir $OUTPUT_DIR
}
