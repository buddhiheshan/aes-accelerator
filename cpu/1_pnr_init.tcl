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

# initialize variables/setup, would recc to do this in gui, can save it as a .globals
set DATE [clock format [clock seconds] -format "%b%d"] 
set OUTPUT_DIR "pnr/output_${DATE}"

puts "INFO: Loading Libraries..."

set init_lef_file {/ip/tsmc/tsmc16adfp/tech/APR/N16ADFP_APR_Innovus/N16ADFP_APR_Innovus_11M.10a.tlef /ip/tsmc/tsmc16adfp/pll/LEF/lef/n16adfp_pll_100a_10lm.lef /ip/tsmc/tsmc16adfp/stdcell/LEF/lef/N16ADFP_StdCell.lef /ip/tsmc/tsmc16adfp/sram/LEF/N16ADFP_SRAM_100a.lef /ip/tsmc/tsmc16adfp/stdio/LEF/N16ADFP_StdIO.lef}
set init_original_verilog_files syn/outputs/picorv32_axi.v
set init_verilog syn/outputs/picorv32_axi.v
set init_pwr_nets {"VDD" "VDDM" }
set init_gnd_nets {"VSS"}

set init_lef_check_antenna 1

init_design


#need to add mmmc setup here
