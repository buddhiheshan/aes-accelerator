module axi_sram_512x45_wrapper (
    input  wire         aclk,
    input  wire         aresetn,

    // AXI4-Lite Slave Interface
    input  wire [31:0]  axi_awaddr,
    input  wire         axi_awvalid,
    output reg          axi_awready,

    input  wire [31:0]  axi_wdata,
    input  wire [ 3:0]  axi_wstrb,
    input  wire         axi_wvalid,
    output reg          axi_wready,

    output reg  [ 1:0]  axi_bresp,
    output reg          axi_bvalid,
    input  wire         axi_bready,

    input  wire [31:0]  axi_araddr,
    input  wire         axi_arvalid,
    output reg          axi_arready,

    output reg  [31:0]  axi_rdata,
    output reg  [ 1:0]  axi_rresp,
    output reg          axi_rvalid,
    input  wire         axi_rready
);

    // SRAM Signals
   
    wire        sram_clk_inv; 
    reg         sram_ceb;    
    reg         sram_web;    
    reg  [8:0]  sram_addr;   
    reg  [44:0] sram_din;    
    reg  [44:0] sram_bweb;   
    wire [44:0] sram_dout;   

    reg         read_active;
    reg         write_active;

    // AXI updates data at posedge. SRAM samples at negedge.
    // This creates a 1/2 cycle Setup/Hold margin.
    assign sram_clk_inv = ~aclk; 

    // AXI Logic (Standard Handshake)
    always @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            axi_awready  <= 1'b0;
            axi_wready   <= 1'b0;
            axi_bvalid   <= 1'b0;
            axi_bresp    <= 2'b00;
            write_active <= 1'b0;
        end else begin
            // Write Request
            if (axi_awvalid && axi_wvalid && !write_active && !axi_bvalid) begin
                axi_awready  <= 1'b1;
                axi_wready   <= 1'b1;
                write_active <= 1'b1;
            end else begin
                axi_awready  <= 1'b0;
                axi_wready   <= 1'b0;
                write_active <= 1'b0;
            end

            // Write Response
            if (axi_awready && axi_wready) 
                axi_bvalid <= 1'b1;
            else if (axi_bready && axi_bvalid) 
                axi_bvalid <= 1'b0;
        end
    end

    always @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            axi_arready <= 1'b0;
            axi_rvalid  <= 1'b0;
            axi_rresp   <= 2'b00;
            read_active <= 1'b0;
        end else begin
            // Read Request
            if (axi_arvalid && !read_active && !axi_rvalid) begin
                read_active <= 1'b1;
                axi_arready <= 1'b1;
            end else begin
                read_active <= 1'b0;
                axi_arready <= 1'b0;
            end

            // Read Response
            if (axi_arready) 
                axi_rvalid <= 1'b1;
            else if (axi_rready && axi_rvalid) 
                axi_rvalid <= 1'b0;
        end
    end

    // SRAM Interface Logic
    always @(*) begin
        // Defaults (Idle)
        sram_ceb  = 1'b1; 
        sram_web  = 1'b1; 
        sram_addr = 9'b0;
        sram_din  = 45'b0;
        sram_bweb = 45'h1FFFFFFFFFFF; // Mask ALL bits (Active Low)

        if (write_active) begin
            sram_ceb  = 1'b0; // Enable
            sram_web  = 1'b0; // Write
            
            // Addressing: Shift AXI byte address to get Word Index
            sram_addr = axi_awaddr[10:2]; 
            
            // Data: Place 32-bit CPU data into lower 45-bit word
            sram_din  = {13'b0, axi_wdata};

            // Masking (BWEB): 0 = Write, 1 = Protect
            // Map the 4 byte strobes to the lower 32 bits
            sram_bweb[ 7: 0] = axi_wstrb[0] ? 8'h00 : 8'hFF;
            sram_bweb[15: 8] = axi_wstrb[1] ? 8'h00 : 8'hFF;
            sram_bweb[23:16] = axi_wstrb[2] ? 8'h00 : 8'hFF;
            sram_bweb[31:24] = axi_wstrb[3] ? 8'h00 : 8'hFF;
            // Protect upper 13 bits (44 down to 32)
            sram_bweb[44:32] = 13'h1FFF; 
        end 
        else if (read_active) begin
            sram_ceb  = 1'b0; // Enable
            sram_web  = 1'b1; // Read
            sram_addr = axi_araddr[10:2];
            sram_bweb = 45'h1FFFFFFFFFFF; // Protect All
        end
    end

    // Output Mapping
    always @(*) begin
        axi_rdata = sram_dout[31:0];
    end

    // SRAM Instance with CLOCK FIX
    TS1N16ADFPCLLLVTA512X45M4SWSHOD u_sram_512x45 (
        .CLK      (sram_clk_inv),   
        .CEB      (sram_ceb),
        .WEB      (sram_web),
        .A        (sram_addr),   
        .D        (sram_din),    
        .BWEB     (sram_bweb),   
        .Q        (sram_dout),   
        
        // Static Pins
        .SLP(1'b0), .DSLP(1'b0), .SD(1'b0), 
        .RTSEL(2'b01), .WTSEL(2'b01), .PUDELAY()
    );

endmodule