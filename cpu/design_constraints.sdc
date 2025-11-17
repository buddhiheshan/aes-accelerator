set CLK_PERIOD 3

create_clock -name "clk" -period $CLK_PERIOD -waveform {0.0 1.5} [get_ports {clk}]
set_clock_uncertainty 0.01 [get_clocks clk]
set_clock_latency -source 2.0 [get_clocks clk]
set_clock_latency -object 1.5 [get_clocks clk]
set_clock_transition 0.1 [get_clocks clk]
set_input_delay -max 1.0 [get_ports {a,b,c,d, sel, resetn}] -clock [get_clocks "clk"]
set_output_delay -max 1.0 [get_ports out] -clock [get_clocks "clk"] 
