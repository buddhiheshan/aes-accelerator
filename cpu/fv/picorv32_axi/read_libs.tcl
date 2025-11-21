add_search_path /ip/tsmc/tsmc16adfp/stdcell/NLDM /ip/tsmc/tsmc16adfp/sram/NLDM /ip/tsmc/tsmc16adfp/stdio/NLDM /ip/tsmc/tsmc16adfp/pll/LIB -library -both
read_library -liberty -both \
    /ip/tsmc/tsmc16adfp/pll/LIB/n16adfp_plltt0p8v1p8v25c.lib \
    /ip/tsmc/tsmc16adfp/sram/NLDM/N16ADFP_SRAM_tt0p8v0p8v25c_100a.lib \
    /ip/tsmc/tsmc16adfp/stdcell/NLDM/N16ADFP_StdCelltt0p8v25c.lib \
    /ip/tsmc/tsmc16adfp/stdio/NLDM/N16ADFP_StdIOtt0p8v1p8v25c.lib

