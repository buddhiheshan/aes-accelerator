add_search_path /ip/tsmc/tsmc16adfp/stdcell/CCS /ip/tsmc/tsmc16adfp/sram/NLDM /ip/tsmc/tsmc16adfp/stdio/NLDM -library -both
read_library -liberty -both \
    /ip/tsmc/tsmc16adfp/sram/NLDM/N16ADFP_SRAM_ff0p88v0p88vm40c_100a.lib \
    /ip/tsmc/tsmc16adfp/sram/NLDM/N16ADFP_SRAM_ss0p72v0p72v125c_100a.lib \
    /ip/tsmc/tsmc16adfp/sram/NLDM/N16ADFP_SRAM_tt0p8v0p8v25c_100a.lib \
    /ip/tsmc/tsmc16adfp/stdcell/CCS/N16ADFP_StdCellff0p88vm40c_ccs.lib \
    /ip/tsmc/tsmc16adfp/stdcell/CCS/N16ADFP_StdCellss0p72v125c_ccs.lib \
    /ip/tsmc/tsmc16adfp/stdcell/CCS/N16ADFP_StdCelltt0p8v25c_ccs.lib \
    /ip/tsmc/tsmc16adfp/stdio/NLDM/N16ADFP_StdIOff0p88v1p98vm40c.lib \
    /ip/tsmc/tsmc16adfp/stdio/NLDM/N16ADFP_StdIOss0p72v1p62v125c.lib \
    /ip/tsmc/tsmc16adfp/stdio/NLDM/N16ADFP_StdIOtt0p8v1p8v25c.lib

