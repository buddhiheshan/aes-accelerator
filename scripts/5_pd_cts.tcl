# Clock Tree Synthesis
# https://www.youtube.com/watch?v=uQzycGOJWDU
# https://community.cadence.com/cadence_technology_forums/f/digital-implementation/65348/undefined-scan-chain-error-during-innovus-place
set DATE [clock format [clock seconds] -format "%b%d"] 
set REPORT_DIR "physical_design/logs/report_${DATE}"

create_clock_tree_spec
ccopt_design 

opt_design -post_cts -report_dir $REPORT_DIR
opt_design -post_cts -hold -report_dir $REPORT_DIR
opt_design -post_cts -hold -setup -report_dir $REPORT_DIR

#time_design -post_cts -report_dir $REPORT_DIR
#time_design -post_cts -hold -report_dir $REPORT_DIR
