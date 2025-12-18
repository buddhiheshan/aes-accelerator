`timescale 1ns/1ps

module tb_pipeline_reg ();

    logic clk, reset_n;
    logic [127:0] q, d;

    int pass_count = 0;
    int fail_count = 0;

    int N_RANDOM;
    logic [127:0] last_q;

    // DUT
    pipeline_reg dut (
        .d      (d),
        .q      (q),
        .clk    (clk),
        .reset_n(reset_n)
    );

    // Clock: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Waveform dump
    initial begin
        $dumpfile("pipeline_reg.vcd");
        $dumpvars(0, tb_pipeline_reg);
    end

    // ----------------------------------------------------
    // Utility tasks
    // ----------------------------------------------------
    task automatic check_output(string name, logic [127:0] expected_q);
        if (q !== expected_q) begin
            fail_count++;
            $display("[%0t] [FAIL] %s", $time, name);
            $display("  Expected: %032h", expected_q);
            $display("  Got     : %032h", q);
        end
        else begin
            pass_count++;
            $display("[%0t] [PASS] %s", $time, name);
        end
    endtask

    // Wait for N rising edges of clk
    task automatic wait_posedges(int n);
        repeat (n) @(posedge clk);
    endtask

    // Apply stimulus: optionally assert reset, drive d, wait 1 cycle, check q
    task automatic apply_and_check(
        string        name,
        logic [127:0] d_in,
        bit           do_reset,
        logic [127:0] expected_q_after
    );
        // Setup inputs in the "stable" region before a clock edge
        d = d_in;
        if (do_reset)
            reset_n = 0;
        else
            reset_n = 1;

        // One clock edge where the register will update
        wait_posedges(1);
        #1;
        check_output(name, expected_q_after);
        // Deassert reset after the edge (for sync active-low reset)
        if (do_reset)
            reset_n = 1;
        
    endtask

    // ----------------------------------------------------
    // Test sequence
    // ----------------------------------------------------
    initial begin
        // Initialize
        reset_n = 0;
        d       = '0;

        $display("==== Starting tb_pipeline_reg tests ====");

        // Global reset at start
        wait_posedges(1);
        #1;
        check_output("Global reset at start", '0);

        // 1) Load a known value after reset
        apply_and_check("Load 0xFFFFFFFFFFFFFFFF after reset",
                        128'hFFFFFFFFFFFFFFFF_FFFFFFFFFFFFFFFF,
                        /*do_reset*/ 0,
                        128'hFFFFFFFFFFFFFFFF_FFFFFFFFFFFFFFFF);

        // 2) Change d between clocks: q should only update on next posedge
        d = 128'hAAAAAAAAAAAAAAAA_AAAAAAAAAAAAAAAA;
        // Change d *between* clock edges; q should still be previous value
        #3; // somewhere in the middle of the cycle
        check_output("No clock edge yet, q should still hold previous value",
                     128'hFFFFFFFFFFFFFFFF_FFFFFFFFFFFFFFFF);

        // Now on the next clock edge, q should capture the new d
        wait_posedges(1);
        #1;
        check_output("Capture 0xAAAAAAAA... on next clock edge",
                     128'hAAAAAAAAAAAAAAAA_AAAAAAAAAAAAAAAA);

        // 3) Synchronous reset in the middle of operation
        // Drive a new d and assert reset_n low; on next posedge q should go to 0
        d       = 128'h1234567890ABCDEF_0011223344556677;
        reset_n = 0;
        wait_posedges(1);
        #1;
        check_output("Synchronous reset while running", '0);
        reset_n = 1;

        // 4) Load another value after reset released
        apply_and_check("Load 0xDEADBEEF... after reset",
                        128'hDEADBEEFDEADBEEF_DEADBEEFDEADBEEF,
                        /*do_reset*/ 0,
                        128'hDEADBEEFDEADBEEF_DEADBEEFDEADBEEF);

        // 5) A second reset pulse to check repeated reset behavior
        apply_and_check("Second reset pulse",
                        128'hCAFEBABECAFEBABE_CAFEBABECAFEBABE,
                        /*do_reset*/ 1,
                        '0);

        // 6) Randomized tests
        N_RANDOM = 20;
        last_q = q; // current value (likely 0 after reset)

        for (int i = 0; i < N_RANDOM; i++) begin
            logic [127:0] rand_d;

            rand_d = {$urandom(), $urandom(), $urandom(), $urandom()};

            // Drive d just before the posedge
            d = rand_d;
            wait_posedges(1);
            #1;
            check_output($sformatf("Random load %0d", i), rand_d);
            last_q = rand_d;
        end

        // ------------------------------------------------
        // Summary
        // ------------------------------------------------
        $display("==== tb_pipeline_reg summary ====");
        $display("  PASSED: %0d", pass_count);
        $display("  FAILED: %0d", fail_count);

        if (fail_count == 0)
            $display("All tests PASSED ✅");
        else
            $display("Some tests FAILED ❌");

        $finish();
    end

endmodule
