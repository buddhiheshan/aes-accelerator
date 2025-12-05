`timescale 1ns / 1ps

module system_top;

    // Clock and Reset Generation
    reg clk;
    reg resetn;
    wire trap; // Indicates if CPU has halted/crashed

    // Generate 100 MHz Clock (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Generate Reset Sequence
    initial begin
        resetn = 0;
        #200;          // Hold reset for 20 cycles
        resetn = 1;    // Release reset
        
        // Run simulation for 5000ns then stop
        #5000;         
        $display("--- Simulation Timeout ---");
        $finish;
    end

    // AXI4-Lite Bus Wires
    // Write Address Channel
    wire        mem_axi_awvalid;
    wire        mem_axi_awready;
    wire [31:0] mem_axi_awaddr;
    wire [ 2:0] mem_axi_awprot;

    // Write Data Channel
    wire        mem_axi_wvalid;
    wire        mem_axi_wready;
    wire [31:0] mem_axi_wdata;
    wire [ 3:0] mem_axi_wstrb;

    // Write Response Channel
    wire        mem_axi_bvalid;
    wire        mem_axi_bready;

    // Read Address Channel
    wire        mem_axi_arvalid;
    wire        mem_axi_arready;
    wire [31:0] mem_axi_araddr;
    wire [ 2:0] mem_axi_arprot;

    // Read Data Channel
    wire        mem_axi_rvalid;
    wire        mem_axi_rready;
    wire [31:0] mem_axi_rdata;

    // CPU Instance (Master)
    picorv32_axi #(
        .PROGADDR_RESET(32'h0000_0000), // Start executing at Address 0
        .ENABLE_IRQ(0),                 // Disable Interrupts
        .ENABLE_MUL(0),                 // Disable Multiplier
        .ENABLE_DIV(0)                  // Disable Divider
    ) u_cpu (
        .clk            (clk),
        .resetn         (resetn),
        .trap           (trap),

        // AXI Write Address
        .mem_axi_awvalid(mem_axi_awvalid),
        .mem_axi_awready(mem_axi_awready),
        .mem_axi_awaddr (mem_axi_awaddr),
        .mem_axi_awprot (mem_axi_awprot),

        // AXI Write Data
        .mem_axi_wvalid (mem_axi_wvalid),
        .mem_axi_wready (mem_axi_wready),
        .mem_axi_wdata  (mem_axi_wdata),
        .mem_axi_wstrb  (mem_axi_wstrb),

        // AXI Write Response
        .mem_axi_bvalid (mem_axi_bvalid),
        .mem_axi_bready (mem_axi_bready),

        // AXI Read Address
        .mem_axi_arvalid(mem_axi_arvalid),
        .mem_axi_arready(mem_axi_arready),
        .mem_axi_araddr (mem_axi_araddr),
        .mem_axi_arprot (mem_axi_arprot),

        // AXI Read Data
        .mem_axi_rvalid (mem_axi_rvalid),
        .mem_axi_rready (mem_axi_rready),
        .mem_axi_rdata  (mem_axi_rdata)
    );

    // SRAM Wrapper Instance (Slave)
    axi_sram_512x45_wrapper u_sram (
        .aclk           (clk),
        .aresetn        (resetn),

        // Connect directly to CPU wires
        .axi_awaddr     (mem_axi_awaddr),
        .axi_awvalid    (mem_axi_awvalid),
        .axi_awready    (mem_axi_awready),

        .axi_wdata      (mem_axi_wdata),
        .axi_wstrb      (mem_axi_wstrb),
        .axi_wvalid     (mem_axi_wvalid),
        .axi_wready     (mem_axi_wready),

        .axi_bresp      (), // Open (PicoRV32 ignores Write Response value)
        .axi_bvalid     (mem_axi_bvalid),
        .axi_bready     (mem_axi_bready),

        .axi_araddr     (mem_axi_araddr),
        .axi_arvalid    (mem_axi_arvalid),
        .axi_arready    (mem_axi_arready),

        .axi_rdata      (mem_axi_rdata),
        .axi_rresp      (), // Open (PicoRV32 ignores Read Response value)
        .axi_rvalid     (mem_axi_rvalid),
        .axi_rready     (mem_axi_rready)
    );

    // FIRMWARE LOADER (Hierarchical Backdoor Access)
    initial begin
        // Variables for the loader
        reg [44:0] temp_mem [0:511]; // Temp buffer
        integer i;
        integer row_idx, col_idx;

        // A. Load Hex File into Buffer
        // Ensure "firmware.hex" is in your simulation folder!
        $readmemh("firmware.hex", temp_mem);

        // B. Scatter Loop: Move data from Buffer -> Internal 2D Array
        // Your memory is [127:0] Rows x [3:0] Columns
        for (i = 0; i < 512; i = i + 1) begin
            // Calculate Indices based on parameters
            // Address Bits [8:2] = Row (0-127)
            // Address Bits [1:0] = Column (0-3)
            row_idx = i[8:2]; 
            col_idx = i[1:0];

            // FORCE WRITE to the internal array
            // Hierarchy: top -> wrapper -> macro -> MEMORY variable
            u_sram.u_sram_512x45.MEMORY[row_idx][col_idx] = temp_mem[i];
        end

        // C. Debug Print to confirm
        $display("==================================================");
        $display(" SYSTEM TOP: Firmware Loaded Successfully.");
        $display(" Debug Check @ Addr 0: %h", u_sram.u_sram_512x45.MEMORY[0][0]);
        $display("==================================================");
    end

    // Basic Monitoring
    initial begin
        // Monitor key CPU events
        $monitor("Time=%0t | PC_Addr=%h | Write=%b Data=%h | Read=%b Data=%h", 
                 $time, mem_axi_araddr, 
                 mem_axi_wvalid & mem_axi_wready, mem_axi_wdata,
                 mem_axi_rvalid & mem_axi_rready, mem_axi_rdata);
    end
  initial begin
    $fsdbDumpfile("dump.fsdb");
    $fsdbDumpvars;
  end



endmodule
