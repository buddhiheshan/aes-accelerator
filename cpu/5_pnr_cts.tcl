# Clock Tree Synthesis
# https://www.youtube.com/watch?v=uQzycGOJWDU
set DATE [clock format [clock seconds] -format "%b%d"] 
set OUTPUT_DIR "pnr/output_${DATE}"

create_ccopt_clock_tree_spec
ccopt_design

timeDesign -postCTS
optDesign -postCTS
timeDesign -postCT