set CLK_PERIOD 10

create_clock -name "clk" -period $CLK_PERIOD -waveform {0 5} [get_ports {S_AXI_ACLK}]
set_clock_uncertainty 0.01 [get_clocks clk]
set_clock_latency -source 2.0 [get_clocks clk]
# set_clock_latency -object 1.5 [get_clocks clk]
set_clock_transition 0.1 [get_clocks clk]
set_input_delay -max 1.0 [get_ports {S_AXI_AWADDR S_AXI_AWVALID S_AXI_WDATA S_AXI_WSTRB S_AXI_WVALID S_AXI_BREADY S_AXI_ARADDR S_AXI_ARVALID S_AXI_RREADY S_AXI_ARESETN}] -clock [get_clocks "clk"]
set_output_delay -max 1.0 [get_ports {S_AXI_AWREADY S_AXI_WREADY S_AXI_BRESP S_AXI_BVALID S_AXI_ARREADY S_AXI_RDATA S_AXI_RRESP S_AXI_RVALID}] -clock [get_clocks "clk"] 