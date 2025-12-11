set CLK_PERIOD 10

create_clock -name "clk" -period $CLK_PERIOD -waveform {0.0 5} [get_ports {clk}]
set_clock_uncertainty 0.01 [get_clocks clk]
set_clock_latency -source 2.0 [get_clocks clk]
set_clock_transition 0.1 [get_clocks clk] 