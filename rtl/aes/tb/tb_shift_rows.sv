`timescale 1ns/1ps

module tb_shift_rows ();

    // -------------------------------------------------
    // DUT interfaces
    // -------------------------------------------------
    logic [127:0] input_state_encrypt;
    logic [127:0] output_state_encrypt;

    logic [127:0] input_state_decrypt;
    logic [127:0] output_state_decrypt;

    int pass_count = 0;
    int fail_count = 0;

    int N_RANDOM;

    logic [127:0] patt_a5, patt_5a;

    // Encrypt (forward ShiftRows)
    shift_rows #(.INVERSE(0)) dut_encrypt (
        .input_state  (input_state_encrypt),
        .output_state (output_state_encrypt)
    );

    // Decrypt (inverse ShiftRows)
    shift_rows #(.INVERSE(1)) dut_decrypt (
        .input_state  (input_state_decrypt),
        .output_state (output_state_decrypt)
    );

    // -------------------------------------------------
    // Utility tasks
    // -------------------------------------------------
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
        end
        else begin
            pass_count++;
            $display("[%0t] [PASS] %s", $time, name);
        end
    endtask

    task automatic run_enc_vector(
        string        name,
        logic [127:0] in_state,
        logic [127:0] expected_out
    );
        input_state_encrypt = in_state;
        #1; // combinational settle
        check_equal({name, " (encrypt)"}, output_state_encrypt, expected_out);
    endtask

    task automatic run_dec_vector(
        string        name,
        logic [127:0] in_state,
        logic [127:0] expected_out
    );
        input_state_decrypt = in_state;
        #1; // combinational settle
        check_equal({name, " (decrypt)"}, output_state_decrypt, expected_out);
    endtask

    // enc -> dec should be identity
    task automatic check_enc_dec_inverse(
        string        name,
        logic [127:0] state_in
    );
        logic [127:0] mid, last;

        input_state_encrypt = state_in;
        #1;
        mid = output_state_encrypt;

        input_state_decrypt = mid;
        #1;
        last = output_state_decrypt;

        check_equal({name, " (enc->dec == id)"}, last, state_in);
    endtask

    // dec -> enc should be identity
    task automatic check_dec_enc_inverse(
        string        name,
        logic [127:0] state_in
    );
        logic [127:0] mid, last;

        input_state_decrypt = state_in;
        #1;
        mid = output_state_decrypt;

        input_state_encrypt = mid;
        #1;
        last = output_state_encrypt;

        check_equal({name, " (dec->enc == id)"}, last, state_in);
    endtask

    // -------------------------------------------------
    // Test stimulus
    // -------------------------------------------------
    initial begin
        $display("==== Starting tb_shift_rows tests ====");

        // ---------------------------------------------
        // 1. Your known AES test vector (forward & inverse)
        // ---------------------------------------------
        // Forward:  d42711aee0bf98f1b8b45de51e415230
        // ->        d4bf5d30e0b452aeb84111f11e2798e5
        run_enc_vector(
            "Known AES test vector",
            128'hd42711aee0bf98f1b8b45de51e415230,
            128'hd4bf5d30e0b452aeb84111f11e2798e5
        );

        // Inverse:  d4bf5d30e0b452aeb84111f11e2798e5
        // ->        d42711aee0bf98f1b8b45de51e415230
        run_dec_vector(
            "Known AES test vector inverse",
            128'hd4bf5d30e0b452aeb84111f11e2798e5,
            128'hd42711aee0bf98f1b8b45de51e415230
        );

        // ---------------------------------------------
        // 2. Simple patterns (zero, all-ones, alternating)
        // ---------------------------------------------
        // Zero state: ShiftRows is a permutation, so zero stays zero
        run_enc_vector("All zeros encrypt", 128'h0, 128'h0);
        run_dec_vector("All zeros decrypt", 128'h0, 128'h0);

        // Identity via enc->dec and dec->enc on some patterns
        check_enc_dec_inverse("All zeros identity", 128'h0);
        check_enc_dec_inverse("All ones identity", {128{1'b1}});

        check_dec_enc_inverse("All zeros identity (dec->enc)", 128'h0);
        check_dec_enc_inverse("All ones identity (dec->enc)", {128{1'b1}});

        // Alternating patterns
        patt_a5 = 128'hA5A5_A5A5_A5A5_A5A5_A5A5_A5A5_A5A5_A5A5;
        patt_5a = 128'h5A5A_5A5A_5A5A_5A5A_5A5A_5A5A_5A5A_5A5A;

        check_enc_dec_inverse("Pattern A5A5...", patt_a5);
        check_enc_dec_inverse("Pattern 5A5A...", patt_5a);

        // ---------------------------------------------
        // 3. Walking-1 across all bits
        // ---------------------------------------------
        for (int i = 0; i < 128; i++) begin
            logic [127:0] walk_vec = '0;
            walk_vec[i] = 1'b1;
            check_enc_dec_inverse($sformatf("Walking-1 bit %0d", i), walk_vec);
        end

        // ---------------------------------------------
        // 4. Random tests (enc->dec and dec->enc)
        // ---------------------------------------------
        N_RANDOM = 100;
        for (int t = 0; t < N_RANDOM; t++) begin
            logic [127:0] r;
            r = {$urandom(), $urandom(), $urandom(), $urandom()};

            check_enc_dec_inverse($sformatf("Random enc->dec %0d", t), r);
            check_dec_enc_inverse($sformatf("Random dec->enc %0d", t), r);
        end

        // ---------------------------------------------
        // Summary
        // ---------------------------------------------
        $display("==== tb_shift_rows summary ====");
        $display("  PASSED: %0d", pass_count);
        $display("  FAILED: %0d", fail_count);

        if (fail_count == 0)
            $display("All tests PASSED ✅");
        else
            $display("Some tests FAILED ❌");

        $finish;
    end

    // -------------------------------------------------
    // Waveform dump
    // -------------------------------------------------
    initial begin
        $dumpfile("shift_rows.vcd");
        $dumpvars(0, tb_shift_rows);
    end

endmodule
