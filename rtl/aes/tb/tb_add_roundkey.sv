`timescale 1ns/1ps

module tb_add_roundkey;

    // -----------------------------
    // DUT interface
    // -----------------------------
    logic [127:0] input_state;
    logic [127:0] key;
    logic [127:0] output_state;

    int pass_count = 0;
    int fail_count = 0;

    // DUT
    add_roundkey dut(.*);

    int N_RANDOM;

    // -----------------------------
    // Utility tasks
    // -----------------------------
    task automatic check_output(
        string         name,
        logic [127:0]  expected_output_state
    );
        if (output_state !== expected_output_state) begin
            fail_count++;
            $display("[%0t] [FAIL] %s", $time, name);
            $display("  Expected: %032h", expected_output_state);
            $display("  Got     : %032h", output_state);
        end
        else begin
            pass_count++;
            $display("[%0t] [PASS] %s", $time, name);
        end
    endtask

    task automatic run_test(
        string        name,
        logic [127:0] in_state,
        logic [127:0] k
    );
        logic [127:0] expected;

        input_state = in_state;
        key         = k;
        #1; // allow combinational logic to settle

        // For AddRoundKey, expected = state XOR key
        expected = in_state ^ k;

        check_output(name, expected);
    endtask

    // -----------------------------
    // Test stimulus
    // -----------------------------
    initial begin
        $display("==== Starting tb_add_roundkey tests ====");

        //-------------------------------
        // 1. Known AES-style test vector
        //-------------------------------
        run_test(
            "Known AES test vector",
            128'h89c2abb23688ac1c675eb2d4cf2a263e,
            128'h636a224c2c3d021f797f4f5e2b36011b
        );
        // (For reference, expected = eaa889fe1ab5ae031e21fd8ae41c2725)

        //-------------------------------
        // 2. Zero key (output = input_state)
        //-------------------------------
        run_test(
            "Zero key",
            128'h0123456789abcdef_0011223344556677,
            128'h0
        );

        //-------------------------------
        // 3. Zero state (output = key)
        //-------------------------------
        run_test(
            "Zero state",
            128'h0,
            128'hfedcba9876543210_ffeeddccbbaa9988
        );

        //-------------------------------
        // 4. All-ones patterns
        //-------------------------------
        run_test(
            "All ones state, all ones key",
            {128{1'b1}},
            {128{1'b1}}
        );

        run_test(
            "All ones state, zero key",
            {128{1'b1}},
            128'h0
        );

        //-------------------------------
        // 5. Alternating bit patterns
        //-------------------------------
        run_test(
            "Pattern A5/5A",
            128'hA5A5_A5A5_A5A5_A5A5_A5A5_A5A5_A5A5_A5A5,
            128'h5A5A_5A5A_5A5A_5A5A_5A5A_5A5A_5A5A_5A5A
        );

        run_test(
            "Pattern AA/55",
            128'hAAAAAAAA_AAAAAAAA_AAAAAAAA_AAAAAAAA,
            128'h55555555_55555555_55555555_55555555
        );

        //-------------------------------
        // 6. Walking-1 through the state
        //-------------------------------
        for (int i = 0; i < 128; i++) begin
            logic [127:0] walk_state = '0;
            logic [127:0] walk_key   = 128'hDEAD_BEEF_DEAD_BEEF_DEAD_BEEF_DEAD_BEEF;

            walk_state[i] = 1'b1;

            run_test($sformatf("Walking-1 state bit %0d", i),
                     walk_state, walk_key);
        end

        //-------------------------------
        // 7. Walking-1 through the key
        //-------------------------------
        for (int i = 0; i < 128; i++) begin
            logic [127:0] walk_state = 128'hCAFE_F00D_CAFE_F00D_CAFE_F00D_CAFE_F00D;
            logic [127:0] walk_key   = '0;

            walk_key[i] = 1'b1;

            run_test($sformatf("Walking-1 key bit %0d", i),
                     walk_state, walk_key);
        end

        //-------------------------------
        // 8. Randomized tests
        //-------------------------------
        N_RANDOM = 100;
        for (int t = 0; t < N_RANDOM; t++) begin
            logic [127:0] rand_state;
            logic [127:0] rand_key;

            rand_state = {
                $urandom(),
                $urandom(),
                $urandom(),
                $urandom()
            };

            rand_key = {
                $urandom(),
                $urandom(),
                $urandom(),
                $urandom()
            };

            run_test($sformatf("Random test %0d", t), rand_state, rand_key);
        end

        //-------------------------------
        // Summary
        //-------------------------------
        $display("==== tb_add_roundkey summary ====");
        $display("  PASSED: %0d", pass_count);
        $display("  FAILED: %0d", fail_count);

        if (fail_count == 0)
            $display("All tests PASSED ✅");
        else
            $display("Some tests FAILED ❌");

        $finish;
    end

    // -----------------------------
    // Waveform dump
    // -----------------------------
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_add_roundkey);
    end

endmodule
