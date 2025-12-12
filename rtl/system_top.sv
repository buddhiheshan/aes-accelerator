`timescale 1ns / 1ps

// This module contains the synthesizable logic:
// CPU (Master), AXI Interconnect/Decoder, SRAM (Slave), AES (Slave)
module system_top (
    input wire clk,
    input wire resetn,
    output wire trap
);

    // --- 1. Address Map Parameters ---
    localparam SRAM_BASE = 32'h0000_0000;
    localparam SRAM_SIZE = 32'h0000_0200;
    localparam AES_BASE  = 32'h0000_0300;
    
    // --- 2. AXI4-Lite Bus Wires (Internal Interconnect) ---
    // All Master-to-Slave Wires (from CPU)
    wire mem_axi_awvalid, mem_axi_wvalid, mem_axi_bready, mem_axi_arvalid, mem_axi_rready;
    wire [31:0] mem_axi_awaddr, mem_axi_wdata, mem_axi_araddr;
    wire [2:0] mem_axi_awprot, mem_axi_arprot;
    wire [3:0] mem_axi_wstrb;
    
    // All Slave-to-Master Wires (to CPU)
    wire mem_axi_awready, mem_axi_wready, mem_axi_bvalid, mem_axi_arready, mem_axi_rvalid;
    wire [31:0] mem_axi_rdata;

    // --- 3. Slave Interface Wires ---
    wire mem_sram_awready, mem_sram_wready, mem_sram_bvalid, mem_sram_arready, mem_sram_rvalid;
    wire [31:0] mem_sram_rdata;
    
    wire mem_aes_awready, mem_aes_wready, mem_aes_bvalid, mem_aes_arready, mem_aes_rvalid;
    wire [31:0] mem_aes_rdata;

    // --- 4. Address Decoding and Signal Routing (AXI Decoder/Arbiter Logic) ---

    // Decoding
    wire sram_sel_aw = (mem_axi_awaddr >= SRAM_BASE) && (mem_axi_awaddr < (SRAM_BASE + SRAM_SIZE));
    wire aes_sel_aw  = (mem_axi_awaddr >= AES_BASE) && (mem_axi_awaddr < (AES_BASE + 32'h100));
    wire sram_sel_ar = (mem_axi_araddr >= SRAM_BASE) && (mem_axi_araddr < (SRAM_BASE + SRAM_SIZE));
    wire aes_sel_ar  = (mem_axi_araddr >= AES_BASE) && (mem_axi_araddr < (AES_BASE + 32'h100));

    // AXI Ready/Valid Aggregation (OR logic for simultaneous selection is simplified here)
    assign mem_axi_awready = (sram_sel_aw ? mem_sram_awready : 1'b0) | (aes_sel_aw  ? mem_aes_awready  : 1'b0);
    assign mem_axi_wready  = (sram_sel_aw ? mem_sram_wready  : 1'b0) | (aes_sel_aw  ? mem_aes_wready   : 1'b0);
    assign mem_axi_arready = (sram_sel_ar ? mem_sram_arready : 1'b0) | (aes_sel_ar  ? mem_aes_arready  : 1'b0);
    
    // AXI Valid/Response Muxing (Prioritize SRAM if both select bits assert due to faulty addressing, but here they should be mutually exclusive)
    assign mem_axi_bvalid = (sram_sel_aw ? mem_sram_bvalid : 1'b0) | (aes_sel_aw  ? mem_aes_bvalid  : 1'b0);
    assign mem_axi_rvalid = (sram_sel_ar ? mem_sram_rvalid : 1'b0) | (aes_sel_ar  ? mem_aes_rvalid  : 1'b0);
    assign mem_axi_rdata = (sram_sel_ar & mem_sram_rvalid) ? mem_sram_rdata : 
                           (aes_sel_ar & mem_aes_rvalid)  ? mem_aes_rdata  : 32'h0000_0000;

    // AXI Valid Demultiplexing
    wire sram_arvalid = mem_axi_arvalid & sram_sel_ar;
    wire aes_arvalid  = mem_axi_arvalid & aes_sel_ar;
    wire sram_awvalid = mem_axi_awvalid & sram_sel_aw;
    wire aes_awvalid  = mem_axi_awvalid & aes_sel_aw;
    wire sram_wvalid  = mem_axi_wvalid  & sram_sel_aw; 
    wire aes_wvalid   = mem_axi_wvalid  & aes_sel_aw;

    // --- 5. Component Instantiations ---
    
    // CPU Instance (AXI Master)
    picorv32_axi #(
        .PROGADDR_RESET(SRAM_BASE),
        .ENABLE_IRQ(0),
        .ENABLE_MUL(0),
        .ENABLE_DIV(0)
    ) u_cpu (
        .clk              (clk),
        .resetn           (resetn),
        .trap             (trap),
        // AXI Interface connections...
        .mem_axi_awvalid(mem_axi_awvalid), .mem_axi_awready(mem_axi_awready), .mem_axi_awaddr (mem_axi_awaddr), .mem_axi_awprot (mem_axi_awprot),
        .mem_axi_wvalid (mem_axi_wvalid),  .mem_axi_wready (mem_axi_wready),  .mem_axi_wdata  (mem_axi_wdata),  .mem_axi_wstrb  (mem_axi_wstrb),
        .mem_axi_bvalid (mem_axi_bvalid),  .mem_axi_bready (mem_axi_bready),
        .mem_axi_arvalid(mem_axi_arvalid), .mem_axi_arready(mem_axi_arready), .mem_axi_araddr (mem_axi_araddr), .mem_axi_arprot (mem_axi_arprot),
        .mem_axi_rvalid (mem_axi_rvalid),  .mem_axi_rready (mem_axi_rready),  .mem_axi_rdata  (mem_axi_rdata)
    );

    // SRAM Wrapper Instance (AXI Slave)
    axi_sram_512x45_wrapper u_sram (
        .aclk           (clk),
        .aresetn        (resetn),
        .axi_awaddr     (mem_axi_awaddr),
        .axi_awvalid    (sram_awvalid),
        .axi_awready    (mem_sram_awready),
        .axi_wdata      (mem_axi_wdata),
        .axi_wstrb      (mem_axi_wstrb),
        .axi_wvalid     (sram_wvalid),
        .axi_wready     (mem_sram_wready),
        .axi_bresp      (),
        .axi_bvalid     (mem_sram_bvalid),
        .axi_bready     (mem_axi_bready),
        .axi_araddr     (mem_axi_araddr),
        .axi_arvalid    (sram_arvalid),
        .axi_arready    (mem_sram_arready),
        .axi_rdata      (mem_sram_rdata),
        .axi_rresp      (),
        .axi_rvalid     (mem_sram_rvalid),
        .axi_rready     (mem_axi_rready)
    );

    // AES Wrapper Instance (AXI Slave)
    top_aes #(
        .BASE_ADDR(AES_BASE)
    ) u_aes (
        .S_AXI_ACLK     (clk),
        .S_AXI_ARESETN  (resetn),
        .S_AXI_AWADDR   (mem_axi_awaddr),
        .S_AXI_AWVALID  (aes_awvalid),
        .S_AXI_AWREADY  (mem_aes_awready),
        .S_AXI_WDATA    (mem_axi_wdata),
        .S_AXI_WSTRB    (mem_axi_wstrb),
        .S_AXI_WVALID   (aes_wvalid),
        .S_AXI_WREADY   (mem_aes_wready),
        .S_AXI_BRESP    (),
        .S_AXI_BVALID   (mem_aes_bvalid),
        .S_AXI_BREADY   (mem_axi_bready),
        .S_AXI_ARADDR   (mem_axi_araddr),
        .S_AXI_ARVALID  (aes_arvalid),
        .S_AXI_ARREADY  (mem_aes_arready),
        .S_AXI_RDATA    (mem_aes_rdata),
        .S_AXI_RRESP    (),
        .S_AXI_RVALID   (mem_aes_rvalid),
        .S_AXI_RREADY   (mem_axi_rready)
    );

endmodule
