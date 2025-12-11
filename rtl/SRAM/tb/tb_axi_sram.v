`timescale 1ns / 1ps

module tb_axi_sram;

    // Signal Declarations
    reg         aclk;
    reg         aresetn;

    // Write Address Channel
    reg  [31:0] axi_awaddr;
    reg         axi_awvalid;
    wire        axi_awready;

    // Write Data Channel
    reg  [31:0] axi_wdata;
    reg  [ 3:0] axi_wstrb;
    reg         axi_wvalid;
    wire        axi_wready;

    // Write Response Channel
    wire [ 1:0] axi_bresp;
    wire        axi_bvalid;
    reg         axi_bready;

    // Read Address Channel
    reg  [31:0] axi_araddr;
    reg         axi_arvalid;
    wire        axi_arready;

    // Read Data Channel
    wire [31:0] axi_rdata;
    wire [ 1:0] axi_rresp;
    wire        axi_rvalid;
    reg         axi_rready;

    //DUT Instantiation
    axi_sram_512x45_wrapper u_dut (
        .aclk           (aclk),
        .aresetn        (aresetn),

        .axi_awaddr     (axi_awaddr),
        .axi_awvalid    (axi_awvalid),
        .axi_awready    (axi_awready),

        .axi_wdata      (axi_wdata),
        .axi_wstrb      (axi_wstrb),
        .axi_wvalid     (axi_wvalid),
        .axi_wready     (axi_wready),

        .axi_bresp      (axi_bresp),
        .axi_bvalid     (axi_bvalid),
        .axi_bready     (axi_bready),

        .axi_araddr     (axi_araddr),
        .axi_arvalid    (axi_arvalid),
        .axi_arready    (axi_arready),

        .axi_rdata      (axi_rdata),
        .axi_rresp      (axi_rresp),
        .axi_rvalid     (axi_rvalid),
        .axi_rready     (axi_rready)
    );
  initial begin
    $fsdbDumpfile("dump.fsdb");
    $fsdbDumpvars;
  end
    // Clock Generation (100MHz)
    initial aclk = 0;
    always #5 aclk = ~aclk;

    // Test Sequence
    initial begin
        // --- Initialization ---
        $display("### Starting Simulation ###");
        aresetn = 0;
        
        // Initialize Inputs to 0
        axi_awaddr = 0; axi_awvalid = 0;
        axi_wdata = 0;  axi_wstrb = 0;   axi_wvalid = 0;
        axi_bready = 0;
        axi_araddr = 0; axi_arvalid = 0;
        axi_rready = 0;

        // Apply Reset
        repeat (5) @(posedge aclk);
        aresetn = 1;
        repeat (5) @(posedge aclk);

        // WRITE TRANSACTION 
        $display("[Time %0t] Writing 0xDEADBEEF to Address 0x100...", $time);
        
        // Assert Address and Data
        axi_awaddr  <= 32'h0000_0100; // Target Address
        axi_awvalid <= 1'b1;
        axi_wdata   <= 32'hDEADBEEF;  // Target Data
        axi_wvalid  <= 1'b1;
        axi_wstrb   <= 4'b1111;       // Write all bytes

        // Wait for Ready signals (Simple handshake)
        wait (axi_awready && axi_wready);
        @(posedge aclk);
        
        // Deassert Valid signals
        axi_awvalid <= 1'b0;
        axi_wvalid  <= 1'b0;

        // Accept Response
        axi_bready <= 1'b1;
        wait (axi_bvalid);
        @(posedge aclk);
        axi_bready <= 1'b0;
        
        $display("[Time %0t] Write Complete.", $time);
        repeat (5) @(posedge aclk); // Idle gap


        // READ TRANSACTION 
        $display("[Time %0t] Reading from Address 0x100...", $time);

        // Assert Read Address
        axi_araddr  <= 32'h0000_0100;
        axi_arvalid <= 1'b1;

        // Wait for Address Ready
        wait (axi_arready);
        @(posedge aclk);
        axi_arvalid <= 1'b0;

        // Wait for Data Valid and Accept it
        axi_rready <= 1'b1;
        wait (axi_rvalid);
        
        // Check Data
        if (axi_rdata === 32'hDEADBEEF) begin
             $display("[PASS] Read Data matches: %h", axi_rdata);
        end else begin
             $display("[FAIL] Read Data Mismatch! Expected: DEADBEEF, Got: %h", axi_rdata);
        end

        @(posedge aclk);
        axi_rready <= 1'b0;

        // Finish 
        repeat (10) @(posedge aclk);
        $display("### Simulation Finished ###");
        $finish;
    end

endmodule