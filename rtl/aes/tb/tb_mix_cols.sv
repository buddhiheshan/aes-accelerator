`timescale 1ns/1ps

module tb_mix_cols;

    // --------------------------------
    // DUT interfaces
    // --------------------------------
    logic [127:0] input_state_encrypt;
    logic [127:0] output_state_encrypt;

    logic [127:0] input_state_decrypt;
    logic [127:0] output_state_decrypt;

    int pass_count = 0;
    int fail_count = 0;

    int N_LINEARITY, N_RANDOM;

    // Encrypt (forward MixColumns)
    mix_cols #(.INVERSE(0)) dut_encrypt (
        .input_state  (input_state_encrypt),
        .output_state (output_state_encrypt)
    );

    // Decrypt (inverse MixColumns)
    mix_cols #(.INVERSE(1)) dut_decrypt (
        .input_state  (input_state_decrypt),
        .output_state (output_state_decrypt)
    );

    // --------------------------------
    // Utility tasks
    // --------------------------------
    task automatic check_equal(
        string        name,
        logic [127:0] got,
        logic [127:0] expected
    );
        if (got !== expected) begin
            fail_count++;
            $display("[%0t] [FAIL] %s", $time, name);
            $display("  Expected: %032h", expected);
            $display("  Got     : %032h", got);
        end else begin
            pass_count++;
            $display("[%0t] [PASS] %s", $time, name);
        end
    endtask

    // Single encrypt-side directed test
    task automatic run_enc_vector(
        string        name,
        logic [127:0] in_state,
        logic [127:0] expected_out
    );
        input_state_encrypt = in_state;
        #1; // combinational settle
        check_equal({name, " (encrypt)"}, output_state_encrypt, expected_out);
    endtask

    // Single decrypt-side directed test
    task automatic run_dec_vector(
        string        name,
        logic [127:0] in_state,
        logic [127:0] expected_out
    );
        input_state_decrypt = in_state;
        #1; // combinational settle
        check_equal({name, " (decrypt)"}, output_state_decrypt, expected_out);
    endtask

    // Check that decrypt(encrypt(x)) == x
    task automatic check_enc_dec_inverse(
        string        name,
        logic [127:0] state_in
    );
        logic [127:0] mid;
        logic [127:0] last;

        // forward MixColumns
        input_state_encrypt = state_in;
        #1;
        mid = output_state_encrypt;

        // inverse MixColumns
        input_state_decrypt = mid;
        #1;
        last = output_state_decrypt;

        check_equal({name, " (enc->dec == id)"}, last, state_in);
    endtask

    // Check that encrypt(decrypt(x)) == x
    task automatic check_dec_enc_inverse(
        string        name,
        logic [127:0] state_in
    );
        logic [127:0] mid;
        logic [127:0] last;

        // inverse MixColumns
        input_state_decrypt = state_in;
        #1;
        mid = output_state_decrypt;

        // forward MixColumns
        input_state_encrypt = mid;
        #1;
        last = output_state_encrypt;

        check_equal({name, " (dec->enc == id)"}, last, state_in);
    endtask

    // Linearity: MC(a ^ b) == MC(a) ^ MC(b)
    task automatic check_linearity(
        string        name,
        logic [127:0] a,
        logic [127:0] b
    );
        logic [127:0] mc_a, mc_b, mc_ab, lhs, rhs;

        // MC(a)
        input_state_encrypt = a;
        #1;
        mc_a = output_state_encrypt;

        // MC(b)
        input_state_encrypt = b;
        #1;
        mc_b = output_state_encrypt;

        // MC(a ^ b)
        input_state_encrypt = a ^ b;
        #1;
        mc_ab = output_state_encrypt;

        lhs = mc_ab;
        rhs = mc_a ^ mc_b;

        check_equal({name, " (linearity: MC(a^b) == MC(a)^MC(b)"}, lhs, rhs);
    endtask

    // --------------------------------
    // Test stimulus
    // --------------------------------
    initial begin
        $display("==== Starting tb_mix_cols tests ====");

        // --------------------------------
        // 1. Your known AES test vector
        // --------------------------------
        // Forward:  d4bf5d30e0b452aeb84111f11e2798e5
        // ->        046681e5e0cb199a48f8d37a2806264c
        run_enc_vector(
            "Known AES test vector",
            128'hd4bf5d30e0b452aeb84111f11e2798e5,
            128'h046681e5e0cb199a48f8d37a2806264c
        );

        // Inverse:  046681e5e0cb199a48f8d37a2806264c
        // ->        d4bf5d30e0b452aeb84111f11e2798e5
        run_dec_vector(
            "Known AES test vector inverse",
            128'h046681e5e0cb199a48f8d37a2806264c,
            128'hd4bf5d30e0b452aeb84111f11e2798e5
        );

        // --------------------------------
        // 2. Simple patterns (zero, all-ones, etc.)
        // --------------------------------
        run_enc_vector(
            "All zeros encrypt",
            128'h0,
            128'h0
        );

        run_dec_vector(
            "All zeros decrypt",
            128'h0,
            128'h0
        );

        // Actually check enc->dec identity instead of assuming expected:
        check_enc_dec_inverse("All ones", {128{1'b1}});

        check_enc_dec_inverse("Zero state", 128'h0);
        check_dec_enc_inverse("Zero state", 128'h0);

        // Alternating patterns
        check_enc_dec_inverse(
            "Pattern A5A5...",
            128'hA5A5_A5A5_A5A5_A5A5_A5A5_A5A5_A5A5_A5A5
        );

        check_enc_dec_inverse(
            "Pattern 5A5A...",
            128'h5A5A_5A5A_5A5A_5A5A_5A5A_5A5A_5A5A_5A5A
        );

        // --------------------------------
        // 3. Walking-1 through the state
        // --------------------------------
        for (int i = 0; i < 128; i++) begin
            logic [127:0] walk_vec = '0;
            walk_vec[i] = 1'b1;
            check_enc_dec_inverse($sformatf("Walking-1 at bit %0d", i), walk_vec);
        end

        // --------------------------------
        // 4. Linearity checks (random)
        // --------------------------------
        N_LINEARITY = 20;
        for (int t = 0; t < N_LINEARITY; t++) begin
            logic [127:0] a, b;
            a = {$urandom(), $urandom(), $urandom(), $urandom()};
            b = {$urandom(), $urandom(), $urandom(), $urandom()};
            check_linearity($sformatf("Linearity test %0d", t), a, b);
        end

        // --------------------------------
        // 5. Random enc->dec identity checks
        // --------------------------------
        N_RANDOM = 100;
        for (int t = 0; t < N_RANDOM; t++) begin
            logic [127:0] r;
            r = {$urandom(), $urandom(), $urandom(), $urandom()};
            check_enc_dec_inverse($sformatf("Random enc->dec %0d", t), r);
            check_dec_enc_inverse($sformatf("Random dec->enc %0d", t), r);
        end

        // --------------------------------
        // Summary
        // --------------------------------
        $display("==== tb_mix_cols summary ====");
        $display("  PASSED: %0d", pass_count);
        $display("  FAILED: %0d", fail_count);

        if (fail_count == 0)
            $display("All tests PASSED ✅");
        else
            $display("Some tests FAILED ❌");

        $finish;
    end

    // --------------------------------
    // Waveform dump
    // --------------------------------
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_mix_cols);
    end

endmodule
