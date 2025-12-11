
set PDK_DIR                  "/ip/tsmc/tsmc16adfp/stdcell"
set PDK_DIR2		     "/ip/tsmc/tsmc16adfp/stdio"
set ADDITIONAL_SEARCH_PATH   "$PDK_DIR/NLDM $PDK_DIR/NDM $PDK_DIR2/NLDM $PDK_DIR2/NDM/N16ADFP_StdIO_physicalonly.ndm ../rtl"  ;#  Directories containing logic libraries, logic design and script files.

set TARGET_LIBRARY_FILES     "N16ADFP_StdCelltt0p8v25c.db N16ADFP_StdIOtt0p8v1p8v25c.db"                              ;#  Logic cell library files


set NDM_DESIGN_LIB           "TOP.dlib"                 ;#  User-defined NDM design library name

set NDM_REFERENCE_LIBS       "N16ADFP_StdCell_physicalonly.ndm reflib.ndm"                 ;#  NDM physical cell libraries

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





analyze -format sverilog {../rtl/pkgs/fsm4_pkg.sv add_roundkey.sv aes_core.sv decryption_fsm.sv decryption.sv dff.sv encryption_fsm.sv encryption.sv key_expansion.sv mix_cols.sv mux.sv pipeline_reg.sv s_box_inv.sv s_box.sv shift_rows.sv sub_bytes_inv.sv sub_bytes.sv top_aes.sv}

elaborate top_aes

list_libs
list_designs



current_design

source top.con
compile_ultra


report_timing



write -format verilog -hierarchy -output TOP_netlist.v

 
write_sdc post_syn.sdc