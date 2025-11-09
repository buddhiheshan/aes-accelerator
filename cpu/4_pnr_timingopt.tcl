set DATE [clock format [clock seconds] -format "%b%d"] 
set OUTPUT_DIR "pnr/output_${DATE}"

timeDesign -preCTS -idealClock -numPaths 50 -prefix preCTS -outDir $OUTPUT_DIR
optDesign -preCTS -drv -outDir $OUTPUT_DIR
