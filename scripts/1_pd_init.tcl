# Innovus 
# *************************************************
# * Local Variable settings for this design
# *************************************************
# * Resources 
# https://www.eng.auburn.edu/~nelson/courses/elec5250_6250/slides/ASIC%20Layout_2%20%20Digital%20Innovus.pdf
# https://digitalsystemdesign.in/pnr-using-innovus-with-scripts/?srsltid=AfmBOoqQYtWIMKeGR4eVudM1Hvt4_MMq7aKaDRwz9VsDofwGRokgGEPk
# https://limsk.ece.gatech.edu/course/ece6133/lab/innovus.pdf using the gui
# https://www.youtube.com/watch?v=jEnQemOC-O0 videos with scripts
# https://community.cadence.com/cadence_technology_forums/f/digital-implementation/57019/proper-timing-analysis-using-innovus-and-genus
# *************************************************

# info for mmmc setup
# 3 library sets for best case, worst case, and typical case
# base case - N16ADFP_StdCellff0p88vm40c_ccs.lib N16ADFP_SRAM_ff0p88v0p88vm40c_100a.lib N16ADFP_StdIOff0p88v1p98vm40c.lib
# worst case - N16ADFP_StdCellss0p72v125c_ccs.lib N16ADFP_SRAM_ss0p72v0p72v125c_100a.lib N16ADFP_StdIOss0p72v1p62v125c.lib 
# typical case - N16ADFP_StdCelltt0p8v25c_ccs.lib N16ADFP_SRAM_tt0p8v0p8v25c_100a.lib N16ADFP_StdIOtt0p8v1p8v25c.lib
# RC corners can be found in /ip/tsmc/tsmc16adfp/tech/tech/RC 
# delay corners select from library and RC corners. OP conds should be default from lib.
# constraint mode from synthesis files



# initialize variables/setup, would recc to do this in gui, can save it as a .globals
set DATE [clock format [clock seconds] -format "%b%d"] 
set OUTPUT_DIR "physical_design/logs/output_${DATE}"

puts "INFO: Loading Libraries..."

set_db design_process_node 16
set init_lef_file {/ip/tsmc/tsmc16adfp/tech/APR/N16ADFP_APR_Innovus/N16ADFP_APR_Innovus_11M.10a.tlef /ip/tsmc/tsmc16adfp/pll/LEF/lef/n16adfp_pll_100a_10lm.lef /ip/tsmc/tsmc16adfp/stdcell/LEF/lef/N16ADFP_StdCell.lef /ip/tsmc/tsmc16adfp/sram/LEF/N16ADFP_SRAM_100a.lef /ip/tsmc/tsmc16adfp/stdio/LEF/N16ADFP_StdIO.lef}
# set init_original_verilog_files syn/outputs/picorv32_axi.v
set init_verilog syn/outputs/system_top.v
set init_top_cell "system_top"
set init_pwr_nets {"VDD"}
#"VPP" "VDDM" "DVDD" "AHVDD"
set init_gnd_nets {"VSS"}
# "VBB" "DVSS" "AHVSS"
#/ip/tsmc/tsmc16adfp/tech/APR/N16ADFP_APR_Innovus/N16ADFP_APR_Innovus_11M.10a.tlef /ip/tsmc/tsmc16adfp/pll/LEF/lef/n16adfp_pll_100a_10lm.lef /ip/tsmc/tsmc16adfp/sram/LEF/N16ADFP_SRAM_100a.lef /ip/tsmc/tsmc16adfp/stdcell/LEF/lef/N16ADFP_StdCell.lef /ip/tsmc/tsmc16adfp/stdio/LEF/N16ADFP_StdIO.lef
set init_lef_check_antenna 1

init_design