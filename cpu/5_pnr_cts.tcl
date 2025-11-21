# Clock Tree Synthesis
# https://www.youtube.com/watch?v=uQzycGOJWDU
# https://community.cadence.com/cadence_technology_forums/f/digital-implementation/65348/undefined-scan-chain-error-during-innovus-place
set DATE [clock format [clock seconds] -format "%b%d"] 
set OUTPUT_DIR "pnr/output_${DATE}"

create_clock_tree_spec
ccopt_design 

time_design -post_cts -report_dir $OUTPUT_DIR
opt_design -post_cts -report_dir $OUTPUT_DIR
