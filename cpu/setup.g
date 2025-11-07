# *************************************************
# * Local Variable settings for this design
# *************************************************
set LOCAL_DIR "[exec pwd]"
set SYNTH_DIR $LOCAL_DIR
set RTL_PATH $LOCAL_DIR/picorv32
set LIB_PATH {/ip/tsmc/tsmc16adfp/stdcell/CCS}

set LIBRARY_LEF_FILES [list "/ip/tsmc/tsmc16adfp/stdcell/LEF/lef/N16ADFP_StdCell.lef" "/ip/tsmc/tsmc16adfp/sram/LEF/N16ADFP_SRAM_100a.lef"]
set TIMING_LIB_FILES [list "/ip/tsmc/tsmc16adfp/stdcell/CCS/N16ADFP_StdCellss0p72v125c_ccs.lib" "/ip/tsmc/tsmc16adfp/sram/NLDM/N16ADFP_SRAM_ss0p72v0p72v125c_100a.lib"]
set TECH_FILE "/ip/tsmc/tsmc16adfp/tech/APR/N16ADFP_APR_ICC2/N16ADFP_APR_ICC2_11M.10a.tf"
set LIBRARY  {N16ADFP_StdCellss0p72v125c_ccs.lib}

set FILE_LIST  {picorv32.v}
set SYN_EFFORT   high
set MAP_EFFORT   high
set DESIGN       {picorv32_axi}
set SDC_FILE design_constraints.sdc
set THE_DATE  [exec date +%m%d.%H%M]

# *********************************************************
# * Display the system info and Start Time
# *********************************************************
puts "The output file  PREFIX is ${THE_DATE} \n"

set_db information_level 9 
set_db hdl_search_path ${RTL_PATH} 
set_db lib_search_path ${LIB_PATH} 

