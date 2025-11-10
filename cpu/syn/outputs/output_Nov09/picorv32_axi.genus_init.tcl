################################################################################
#
# Init setup file
# Created by Genus(TM) Synthesis Solution on 11/09/2025 13:54:02
#
################################################################################
if { ![is_common_ui_mode] } { error "ERROR: This script requires common_ui to be active."}

read_netlist syn/outputs/output_Nov09/picorv32_axi.v

init_design
