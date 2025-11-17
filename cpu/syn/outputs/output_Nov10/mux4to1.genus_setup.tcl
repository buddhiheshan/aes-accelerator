################################################################################
#
# Genus(TM) Synthesis Solution setup file
# Created by Genus(TM) Synthesis Solution 23.14-s090_1
#   on 11/10/2025 18:02:18
#
# This file can only be run in Genus Common UI mode.
#
################################################################################


# This script is intended for use with Genus(TM) Synthesis Solution version 23.14-s090_1


# Remove Existing Design
################################################################################
if {[::legacy::find -design design:mux4to1] ne ""} {
  puts "** A design with the same name is already loaded. It will be removed. **"
  delete_obj design:mux4to1
}


# To allow user-readonly attributes
################################################################################
::legacy::set_attribute -quiet force_tui_is_remote 1 /

phys::read_script syn/outputs/output_Nov10/mux4to1.root.g


# Libraries
################################################################################
::legacy::set_attribute library {/ip/tsmc/tsmc16adfp/stdcell/CCS/N16ADFP_StdCellss0p72v125c_ccs.lib /ip/tsmc/tsmc16adfp/stdcell/CCS/N16ADFP_StdCellff0p88vm40c_ccs.lib /ip/tsmc/tsmc16adfp/stdcell/CCS/N16ADFP_StdCelltt0p8v25c_ccs.lib /ip/tsmc/tsmc16adfp/sram/NLDM/N16ADFP_SRAM_ss0p72v0p72v125c_100a.lib /ip/tsmc/tsmc16adfp/sram/NLDM/N16ADFP_SRAM_ff0p88v0p88vm40c_100a.lib /ip/tsmc/tsmc16adfp/sram/NLDM/N16ADFP_SRAM_tt0p8v0p8v25c_100a.lib /ip/tsmc/tsmc16adfp/stdio/NLDM/N16ADFP_StdIOss0p72v1p62v125c.lib /ip/tsmc/tsmc16adfp/stdio/NLDM/N16ADFP_StdIOff0p88v1p98vm40c.lib /ip/tsmc/tsmc16adfp/stdio/NLDM/N16ADFP_StdIOtt0p8v1p8v25c.lib /ip/tsmc/tsmc16adfp/pll/LIB/n16adfp_pllff0p88v1p98vm40c.lib /ip/tsmc/tsmc16adfp/pll/LIB/n16adfp_pllss0p72v1p62v125c.lib /ip/tsmc/tsmc16adfp/pll/LIB/n16adfp_plltt0p8v1p8v25c.lib} /


# Design
################################################################################
read_netlist -top mux4to1 syn/outputs/output_Nov10/mux4to1.v
read_metric -id current syn/outputs/output_Nov10/mux4to1.metrics.json

phys::read_script syn/outputs/output_Nov10/mux4to1.g

phys::read_lec_taf syn/outputs/output_Nov10/mux4to1.lec.taf.gz
phys::read_taf syn/outputs/output_Nov10/mux4to1.safety.taf.gz
puts "\n** Restoration Completed **\n"


# Data Integrity Check
################################################################################
# program version
if {"[string_representation [::legacy::get_attribute program_version /]]" != "23.14-s090_1"} {
   mesg_send [::legacy::find -message /messages/PHYS/PHYS-91] "golden program_version: 23.14-s090_1  current program_version: [string_representation [::legacy::get_attribute program_version /]]"
}
# license
if {"[string_representation [::legacy::get_attribute startup_license /]]" != "Genus_Synthesis"} {
   mesg_send [::legacy::find -message /messages/PHYS/PHYS-91] "golden license: Genus_Synthesis  current license: [string_representation [::legacy::get_attribute startup_license /]]"
}
# slack
set _slk_ [::legacy::get_attribute slack design:mux4to1]
if {[regexp {^-?[0-9.]+$} $_slk_]} {
  set _slk_ [format %.1f $_slk_]
}
if {$_slk_ != "inf"} {
   mesg_send [::legacy::find -message /messages/PHYS/PHYS-92] "golden slack: inf,  current slack: $_slk_"
}
unset _slk_
# multi-mode slack
# tns
set _tns_ [::legacy::get_attribute tns design:mux4to1]
if {[regexp {^-?[0-9.]+$} $_tns_]} {
  set _tns_ [format %.0f $_tns_]
}
if {$_tns_ != "0"} {
   mesg_send [::legacy::find -message /messages/PHYS/PHYS-92] "golden tns: 0,  current tns: $_tns_"
}
unset _tns_
# cell area
set _cell_area_ [::legacy::get_attribute cell_area design:mux4to1]
if {[regexp {^-?[0-9.]+$} $_cell_area_]} {
  set _cell_area_ [format %.0f $_cell_area_]
}
if {$_cell_area_ != "4"} {
   mesg_send [::legacy::find -message /messages/PHYS/PHYS-92] "golden cell area: 4,  current cell area: $_cell_area_"
}
unset _cell_area_
# net area
set _net_area_ [::legacy::get_attribute net_area design:mux4to1]
if {[regexp {^-?[0-9.]+$} $_net_area_]} {
  set _net_area_ [format %.0f $_net_area_]
}
if {$_net_area_ != "0"} {
   mesg_send [::legacy::find -message /messages/PHYS/PHYS-92] "golden net area: 0,  current net area: $_net_area_"
}
unset _net_area_
