module tb_sub_bytes_inv;
  timeunit 1ns/1ps;

  // ------------------------------------------------
  // DUT I/O
  // ------------------------------------------------
  logic [127:0] isb_in;
  logic [127:0] isb_out;

  // DUT (purely combinational)
  sub_bytes_inv dut (
    .in  (isb_in),
    .out (isb_out)
  );

  // ------------------------------------------------
  // Reference AES inverse S-box (FIPS-197)
  // INV_SBOX[byte] -> substituted byte
  // ------------------------------------------------
  localparam logic [7:0] AES_INV_SBOX [0:255] = '{
    8'h52, 8'h09, 8'h6a, 8'hd5, 8'h30, 8'h36, 8'ha5, 8'h38, 8'hbf, 8'h40, 8'ha3, 8'h9e, 8'h81, 8'hf3, 8'hd7, 8'hfb,
    8'h7c, 8'he3, 8'h39, 8'h82, 8'h9b, 8'h2f, 8'hff, 8'h87, 8'h34, 8'h8e, 8'h43, 8'h44, 8'hc4, 8'hde, 8'he9, 8'hcb,
    8'h54, 8'h7b, 8'h94, 8'h32, 8'ha6, 8'hc2, 8'h23, 8'h3d, 8'hee, 8'h4c, 8'h95, 8'h0b, 8'h42, 8'hfa, 8'hc3, 8'h4e,
    8'h08, 8'h2e, 8'ha1, 8'h66, 8'h28, 8'hd9, 8'h24, 8'hb2, 8'h76, 8'h5b, 8'ha2, 8'h49, 8'h6d, 8'h8b, 8'hd1, 8'h25,
    8'h72, 8'hf8, 8'hf6, 8'h64, 8'h86, 8'h68, 8'h98, 8'h16, 8'hd4, 8'ha4, 8'h5c, 8'hcc, 8'h5d, 8'h65, 8'hb6, 8'h92,
    8'h6c, 8'h70, 8'h48, 8'h50, 8'hfd, 8'hed, 8'hb9, 8'hda, 8'h5e, 8'h15, 8'h46, 8'h57, 8'ha7, 8'h8d, 8'h9d, 8'h84,
    8'h90, 8'hd8, 8'hab, 8'h00, 8'h8c, 8'hbc, 8'hd3, 8'h0a, 8'hf7, 8'he4, 8'h58, 8'h05, 8'hb8, 8'hb3, 8'h45, 8'h06,
    8'hd0, 8'h2c, 8'h1e, 8'h8f, 8'hca, 8'h3f, 8'h0f, 8'h02, 8'hc1, 8'haf, 8'hbd, 8'h03, 8'h01, 8'h13, 8'h8a, 8'h6b,
    8'h3a, 8'h91, 8'h11, 8'h41, 8'h4f, 8'h67, 8'hdc, 8'hea, 8'h97, 8'hf2, 8'hcf, 8'hce, 8'hf0, 8'hb4, 8'he6, 8'h73,
    8'h96, 8'hac, 8'h74, 8'h22, 8'he7, 8'had, 8'h35, 8'h85, 8'he2, 8'hf9, 8'h37, 8'he8, 8'h1c, 8'h75, 8'hdf, 8'h6e,
    8'h47, 8'hf1, 8'h1a, 8'h71, 8'h1d, 8'h29, 8'hc5, 8'h89, 8'h6f, 8'hb7, 8'h62, 8'h0e, 8'haa, 8'h18, 8'hbe, 8'h1b,
    8'hfc, 8'h56, 8'h3e, 8'h4b, 8'hc6, 8'hd2, 8'h79, 8'h20, 8'h9a, 8'hdb, 8'hc0, 8'hfe, 8'h78, 8'hcd, 8'h5a, 8'hf4,
    8'h1f, 8'hdd, 8'ha8, 8'h33, 8'h88, 8'h07, 8'hc7, 8'h31, 8'hb1, 8'h12, 8'h10, 8'h59, 8'h27, 8'h80, 8'hec, 8'h5f,
    8'h60, 8'h51, 8'h7f, 8'ha9, 8'h19, 8'hb5, 8'h4a, 8'h0d, 8'h2d, 8'he5, 8'h7a, 8'h9f, 8'h93, 8'hc9, 8'h9c, 8'hef,
    8'ha0, 8'he0, 8'h3b, 8'h4d, 8'hae, 8'h2a, 8'hf5, 8'hb0, 8'hc8, 8'heb, 8'hbb, 8'h3c, 8'h83, 8'h53, 8'h99, 8'h61,
    8'h17, 8'h2b, 8'h04, 8'h7e, 8'hba, 8'h77, 8'hd6, 8'h26, 8'he1, 8'h69, 8'h14, 8'h63, 8'h55, 8'h21, 8'h0c, 8'h7d
  };

  // Reference inv_sub_bytes on 128b word (LSB = byte 0)
  function automatic logic [127:0] inv_sub_bytes_ref(input logic [127:0] in);
    logic [127:0] out;
    for (int i = 0; i < 16; i++) begin
      out[i*8 +: 8] = AES_INV_SBOX[in[i*8 +: 8]];
    end
    return out;
  endfunction

  // ------------------------------------------------
  // Scoreboard helpers
  // ------------------------------------------------
  int pass_count = 0;
  int fail_count = 0;

  int N_RANDOM;

  task automatic check_equal(
    string        name,
    logic [127:0] got,
    logic [127:0] expected
  );
    if (got !== expected) begin
      fail_count++;
      $display("[%0t] [FAIL] %s", $time, name);
      $display("  Expected: 0x%032h", expected);
      $display("  Got     : 0x%032h", got);
    end else begin
      pass_count++;
      $display("[%0t] [PASS] %s", $time, name);
    end
  endtask

  task automatic run_vec(string name, logic [127:0] vec_in);
    logic [127:0] exp;
    isb_in = vec_in;
    #1; // comb settle
    exp   = inv_sub_bytes_ref(vec_in);
    check_equal(name, isb_out, exp);
  endtask

  // ------------------------------------------------
  // Waves
  // ------------------------------------------------
  initial begin
    // FSDB style
    $fsdbDumpfile("tb_sub_bytes_inv.fsdb");
    $fsdbDumpvars(0, tb_sub_bytes_inv);
    // Or VCD if you prefer:
    $dumpfile("sub_bytes_inv.vcd");
    $dumpvars(0, tb_sub_bytes_inv);
  end

  // ------------------------------------------------
  // Stimulus
  // ------------------------------------------------
  initial begin
    $display("=== Start tb_inv_sub_bytes (purely combinational) ===");

    // ---------------------------
    // 1. Directed vectors
    //    Use the SAME inputs as forward SubBytes TB,
    //    but now check against inverse S-box.
    // ---------------------------

    // Vec 1: 00..0F (LSB is byte 0)
    run_vec("Vec1: 0x0f0e..0100",
            128'h0f0e0d0c0b0a09080706050403020100);

    // Vec 2: all zeros
    run_vec("Vec2: all zeros",
            128'h00000000000000000000000000000000);

    // Vec 3: all FF
    run_vec("Vec3: all 0xFF",
            128'hffffffffffffffffffffffffffffffff);

    // Vec 4: pattern
    run_vec("Vec4: 0x00112233..ffeeddcc",
            128'h00112233445566778899aabbccddeeff);

    // ---------------------------
    // 2. Walking-1 across bits
    // ---------------------------
    for (int i = 0; i < 128; i++) begin
      logic [127:0] walk = '0;
      walk[i] = 1'b1;
      run_vec($sformatf("Walking-1 bit %0d", i), walk);
    end

    // ---------------------------
    // 3. Random tests
    // ---------------------------
    N_RANDOM = 100;
    for (int t = 0; t < N_RANDOM; t++) begin
      logic [127:0] r;
      r = {$urandom(), $urandom(), $urandom(), $urandom()};
      run_vec($sformatf("Random vec %0d", t), r);
    end

    // ---------------------------
    // (Optional) Forward+Inverse Identity Checks
    // If you also have a forward sub_bytes module and want
    // to make sure inv_sub_bytes(sub_bytes(x)) == x,
    // you can add that here later.
    // ---------------------------

    // ---------------------------
    // Summary
    // ---------------------------
    $display("=== tb_inv_sub_bytes summary ===");
    $display("  PASSED: %0d", pass_count);
    $display("  FAILED: %0d", fail_count);

    if (fail_count == 0)
      $display("All tests PASSED ✅");
    else
      $display("Some tests FAILED ❌");

    $display("=== Done ===");
    $finish;
  end

endmodule
