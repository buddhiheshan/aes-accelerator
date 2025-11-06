set CLK_PERIOD 3

create_clock -name "clk" -period $CLK_PERIOD -waveform {0.0 2.5} [get_ports {clk}]
set_clock_uncertainty 0.2 [get_clocks clk]
set_clock_latency -source 2.0 [get_clocks clk]
set_clock_latency -object 1.5 [get_clocks clk]
set_clock_transition 0.3 [get_clocks clk]
set_input_delay 1.0 -clock clk [remove_from_collection [all_inputs] [get_ports {clk resetn}]]
set_output_delay 2.0 -clock clk [all_outputs]