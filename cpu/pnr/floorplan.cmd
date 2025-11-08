#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Thu Nov  6 22:10:30 2025                
#                                                     
#######################################################

#@(#)CDS: Innovus v23.14-s088_1 (64bit) 02/28/2025 12:25 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: NanoRoute 23.14-s088_1 NR250219-0822/23_14-UB (database version 18.20.661) {superthreading v2.20}
#@(#)CDS: AAE 23.14-s018 (64bit) 02/28/2025 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: CTE 23.14-s036_1 () Feb 22 2025 01:17:26 ( )
#@(#)CDS: SYNTECH 23.14-s010_1 () Feb 19 2025 23:56:49 ( )
#@(#)CDS: CPE v23.14-s082
#@(#)CDS: IQuantus/TQuantus 23.1.1-s336 (64bit) Mon Jan 20 22:11:00 PST 2025 (Linux 3.10.0-693.el7.x86_64)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
getVersion
create_library_set -name TYPlib -timing $TIMING_LIB_FILES
create_library_set -name TYPlib -timing $TIMING_LIB_FILES
init_design -netlist /home/jy5187/Documents/soc/aes-accelerator/cpu/syn/outputs/picorv32_axi.v -top picorv32_axi -overwrite
create_library_set -name TYPlib -timing $TIMING_LIB_FILES
create_constraint_mode -name CONSTR_MODE -sdc_files $SDC_FILE
init_design -netlist /home/jy5187/Documents/soc/aes-accelerator/cpu/syn/outputs/picorv32_axi.v -top picorv32_axi -overwrite
create_library_set -name TYPlib -timing $TIMING_LIB_FILES
create_constraint_mode -name CONSTR_MODE -sdc_files $SDC_FILE
create_library_set -name TYPlib -timing $TIMING_LIB_FILES
create_constraint_mode -name CONSTR_MODE -sdc_files $SDC_FILE
create_library_set -name TYPlib -timing $TIMING_LIB_FILES
create_constraint_mode -name CONSTR_MODE -sdc_files $SDC_FILE
win
