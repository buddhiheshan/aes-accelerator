# ####################################################################

#  Created by Genus(TM) Synthesis Solution 23.14-s090_1 on Tue Nov 18 15:09:25 EST 2025

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design picorv32_axi

create_clock -name "clk" -period 3.0 -waveform {0.0 1.5} [get_ports clk]
set_clock_transition 0.1 [get_clocks clk]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports resetn]
set_wire_load_mode "segmented"
set_clock_latency -source 2.0 [get_clocks clk]
set_clock_uncertainty -setup 0.01 [get_clocks clk]
set_clock_uncertainty -hold 0.01 [get_clocks clk]
