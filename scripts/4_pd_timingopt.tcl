set DATE [clock format [clock seconds] -format "%b%d"] 
set REPORT_DIR "physical_design/logs/report_${DATE}"

time_design -pre_cts -num_paths 50 -report_prefix pre_cts 
opt_design -pre_cts -drv -report_dir $OUTPUT_DIR
opt_design -pre_cts -hold -drv -report_dir $OUTPUT_DIR
opt_design -pre_cts -hold -setup -drv -report_dir $OUTPUT_DIR