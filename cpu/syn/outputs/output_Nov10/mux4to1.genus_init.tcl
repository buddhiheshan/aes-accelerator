################################################################################
#
# Init setup file
# Created by Genus(TM) Synthesis Solution on 11/10/2025 18:02:18
#
################################################################################
if { ![is_common_ui_mode] } { error "ERROR: This script requires common_ui to be active."}

read_netlist syn/outputs/output_Nov10/mux4to1.v

init_design
