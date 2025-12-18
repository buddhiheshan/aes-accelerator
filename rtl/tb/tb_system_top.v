`timescale 1ns / 1ps

module tb_system_top;

    // --- 1. Testbench Signals (Clock and Reset) ---
    reg clk;
    reg resetn;
    wire trap; // Output from the DUT

    // --- 2. Clock Generation (100 MHz, 10ns period) ---
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // --- 3. Reset Sequence and Timeout ---
    initial begin
        resetn = 0;
        #200;           // Hold reset for 20 cycles
        resetn = 1;     // Release reset
        
        #50000;       // Run simulation for 5ms then stop
        $display("--- Simulation Timeout ---");
        $finish;
    end

    // --- 4. Instantiate the Design Under Test (DUT) ---
    system_top u_dut (
        .clk    (clk),
        .resetn (resetn),
        .trap   (trap)
    );

    // --- 5. Firmware Loader (Backdoor Access - Non-Synthesizable) ---
    // Note: This block relies on hierarchical access, which is usually fine
    // for simulation but coupling it to the DUT like this is a weak spot.
    // For a cleaner TB, you would pass the SRAM data through ports or use a memory model.
    initial begin
        // Variables for the loader
        reg [44:0] temp_mem [0:511];
        integer i;
        integer row_idx, col_idx;

        // A. Load Hex File into Buffer
        $readmemh("../software/enc_dec_firmware.hex", temp_mem);

        // Wait for reset to be released to ensure the DUT is ready
        @(posedge clk);
        while (resetn == 0) @(posedge clk); 
        
        // B. Scatter Loop: Move data from Buffer -> Internal 2D Array
        for (i = 0; i < 512; i = i + 1) begin
            row_idx = i[8:2]; 
            col_idx = i[1:0];

            // FORCE WRITE to the internal array via hierarchy
            // Hierarchy: tb -> dut -> sram_wrapper -> sram_macro
            u_dut.u_sram.u_sram_512x45.MEMORY[row_idx][col_idx] = temp_mem[i];
        end

        // C. Debug Print to confirm
        $display("==================================================");
        $display(" SYSTEM TOP: Firmware Loaded Successfully.");
        // Note: The debug check needs the full hierarchical path now
        $display(" Debug Check @ Addr 0: %h", u_dut.u_sram.u_sram_512x45.MEMORY[0][0]);
        $display("==================================================");
    end

    // --- 6. Basic Monitoring and Dumping ---
    // These signals must now be accessed via the instance name 'u_dut'
    initial begin
        $monitor("Time=%0t | Addr=%h | Write=%b Data=%h | Read=%b Data=%h | SRAM_Sel=%b AES_Sel=%b", 
                  $time, u_dut.mem_axi_awaddr, 
                  u_dut.mem_axi_wvalid & u_dut.mem_axi_wready, u_dut.mem_axi_wdata,
                  u_dut.mem_axi_rvalid & u_dut.mem_axi_rready, u_dut.mem_axi_rdata,
                  u_dut.sram_sel_aw, u_dut.aes_sel_aw);
    end
    initial begin
        $fsdbDumpfile("dump.fsdb");
        $fsdbDumpvars(0, tb_system_top); // Dump all variables in the tb and below
        $dumpfile("dump.vcd");
        $dumpvars(); 
    end

endmodule
