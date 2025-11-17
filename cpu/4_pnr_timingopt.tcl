set DATE [clock format [clock seconds] -format "%b%d"] 
set OUTPUT_DIR "pnr/output_${DATE}"

time_design -pre_cts -num_paths 50 -report_prefix pre_cts -report_dir $OUTPUT_DIR
opt_design -pre_cts -drv -report_dir $OUTPUT_DIR
