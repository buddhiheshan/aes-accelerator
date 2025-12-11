set PDK_DIR                  "/ip/tsmc/tsmc16adfp/stdcell"
set PDK_DIR2		     "/ip/tsmc/tsmc16adfp/stdio"
set PDK_DIR3					"/ip/tsmc/tsmc16adfp/sram"
set ADDITIONAL_SEARCH_PATH   "$PDK_DIR/NLDM $PDK_DIR2/NLDM $PDK_DIR3/NLDM $PDK_DIR/NDM $PDK_DIR2/NDM ./TOP-sram-cpu/rtl ./aes/rtl ./aes/rtl/pkgs "  ;#  Directories containing logic libraries, logic design and script files.

set TARGET_LIBRARY_FILES     "N16ADFP_StdCelltt0p8v25c.db N16ADFP_StdIOtt0p8v1p8v25c.db N16ADFP_SRAM_tt0p8v0p8v25c_100a.db"                              ;#  Logic cell library files


set NDM_DESIGN_LIB           "TOP.dlib"                 ;#  User-defined NDM design library name

set NDM_REFERENCE_LIBS       "N16ADFP_StdCell_physicalonly.ndm reflib.ndm N16ADFP_StdIO_physicalonly.ndm"                 ;#  NDM physical cell libraries

######################################################################
# Logical Library Settings
######################################################################
set_app_var search_path    "$search_path $ADDITIONAL_SEARCH_PATH"
set_app_var target_library  $TARGET_LIBRARY_FILES
set_app_var link_library   "* $target_library"

######################################################################
# Physical Library Settings
######################################################################


define_design_lib WORK -path ./work         ;# Location of "analyze"d files

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#  Verify Settings
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

echo "\n=================================================================="
echo "\nLibrary Settings:"
echo "search_path:              $search_path"
echo "link_library:             $link_library"
echo "target_library:           $target_library"
echo "physical libraries:       $NDM_REFERENCE_LIBS"
echo "physical design library:  $NDM_DESIGN_LIB"
echo "\n=================================================================="





analyze -format sverilog {fsm4_pkg.sv mux.sv add_roundkey.sv dff.sv key_expansion.sv mix_cols.sv s_box.sv s_box_inv.sv shift_rows.sv sub_bytes.sv sub_bytes_inv.sv pipeline_reg.sv decryption_fsm.sv decryption.sv encryption_fsm.sv encryption.sv aes_core.sv top_aes.sv sram_axi_wrapper.v picorv32.v system_top.v} 

elaborate system_top 

list_libs
list_designs



current_design

read_sdc constraints/design_constraints.sdc 

compile_ultra


report_timing


write -format verilog -hierarchy -output synthesis/files/system_top.v

 
write_sdc synthesis/files/post_syn.sdc
