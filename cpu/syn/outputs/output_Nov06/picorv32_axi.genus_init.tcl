################################################################################
#
# Init setup file
# Created by Genus(TM) Synthesis Solution on 11/06/2025 20:25:16
#
################################################################################
if { ![is_common_ui_mode] } { error "ERROR: This script requires common_ui to be active."}

read_netlist syn/outputs/output_Nov06/picorv32_axi.v

init_design
