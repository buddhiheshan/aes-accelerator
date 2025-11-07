# *************************************************
# * Local Variable settings for this design
# *************************************************
include load_etc.tcl
set LOCAL_DIR "[exec pwd]"
set SYNTH_DIR $LOCAL_DIR
set RTL_PATH $LOCAL_DIR/picorv32
set LIB_PATH {/ip/tsmc/tsmc16adfp/stdcell/CCS}
set LIBRARY  {N16ADFP_StdCellss0p72v125c_ccs.lib}
set FILE_LIST  {example.v}
set SYN_EFFORT   high
set MAP_EFFORT   high
set DESIGN       mux_4to1_assign
set SDC_FILE design_constraints.sdc
set THE_DATE  [exec date +%m%d.%H%M]

# *********************************************************
# * Display the system info and Start Time
# *********************************************************
puts "The output file  PREFIX is ${THE_DATE} \n"

set_db information_level 9 
set_db hdl_search_path ${RTL_PATH} 
set_db lib_search_path ${LIB_PATH} 
