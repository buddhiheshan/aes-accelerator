`timescale 1ns/1ps

module tb_decryption;
  timeunit 1ns/1ps;

  // ---------------------------------
  // DUT signals
  // ---------------------------------
  logic        clk;
  logic        reset_n;

  // Key and key schedule
  logic [127:0] key_in;
  logic [127:0] key_enc;
  logic [127:0] key_dec;
  logic         set_new_key;
  logic         ready_enc;
  logic         ready_dec;

  // Encryption side
  logic [127:0] plain_text_in;
  logic [127:0] cipher_text_out;
  logic         start_enc;
  logic         done_enc;

  // Decryption side
  logic [127:0] cipher_text_in;
  logic [127:0] plain_text_out;
  logic         start_dec;
  logic         done_dec;

  int pass_count = 0;
  int fail_count = 0;

  // ---------------------------------
  // Instantiations
  // ---------------------------------

  // Decryption core
  decryption dut (
    .clk       (clk),
    .plain_text(plain_text_out),   // decrypted plaintext out
    .key_in    (key_dec),
    .reset_n   (reset_n),
    .start     (start_dec),
    .cipher_text(cipher_text_in),
    .ready_dec (ready_dec),
    .done_dec  (done_dec)
  );

  // Encryption core (used to generate ciphertext & round-trip check)
  encryption u_encryption (
    .clk        (clk),
    .plain_text (plain_text_in),
    .key_in     (key_enc),
    .reset_n    (reset_n),
    .start      (start_enc),
    .cipher_text(cipher_text_out),
    .ready_enc  (ready_enc),
    .done_enc   (done_enc)
  );

  // Shared key expansion for both enc & dec
  key_expansion key_expansion_unit (
    .set_new_key (set_new_key),
    .key_in      (key_in),
    .start_enc   (start_enc),
    .ready_enc   (ready_enc),
    .key_enc     (key_enc),
    .start_dec   (start_dec),
    .ready_dec   (ready_dec),
    .key_dec     (key_dec)
  );

  // ---------------------------------
  // Clock
  // ---------------------------------
  initial clk = 1'b0;
  always #5 clk = ~clk; // 100MHz

  // ---------------------------------
  // Waves
  // ---------------------------------
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_decryption);
  end

  // ---------------------------------
  // Utility / scoreboard
  // ---------------------------------
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

  task automatic wait_posedges(int n);
    repeat (n) @(posedge clk);
  endtask

  // Load key through key_expansion and wait for both enc/dec ready
  task automatic load_key(
    string        name,
    logic [127:0] new_key
  );
    $display("[%0t] --- Loading key: %s ---", $time, name);
    key_in      = new_key;
    set_new_key = 1'b1;

    // Let key_expansion see the pulse
    @(posedge clk);
    set_new_key = 1'b0;

    $display("[%0t] Key load done (ready_enc=1, ready_dec=1)", $time);
  endtask

  // Run encryption only (with known-answer test)
  task automatic run_encrypt_test(
    string        name,
    logic [127:0] pt,
    logic [127:0] expected_ct
  );
    $display("[%0t] --- Encryption test: %s ---", $time, name);

    plain_text_in = pt;

    @(posedge clk);
    @(posedge clk);

    // Pulse start
    start_enc = 1'b1;
    @(posedge clk);
    start_enc = 1'b0;

    // Wait for done
    @(posedge done_enc);
    #1; // settle

    check_equal({name, " cipher check"}, cipher_text_out, expected_ct);
  endtask

  // Run decryption only (with known-answer test)
  task automatic run_decrypt_test(
    string        name,
    logic [127:0] ct,
    logic [127:0] expected_pt
  );
    $display("[%0t] --- Decryption test: %s ---", $time, name);

    cipher_text_in = ct;

    @(posedge clk);
    @(posedge clk);

    // Pulse start
    start_dec = 1'b1;
    @(posedge clk);
    start_dec = 1'b0;

    // Wait for done
    @(posedge done_dec);
    #1; // settle

    check_equal({name, " plain check"}, plain_text_out, expected_pt);
  endtask

  // Encrypt then decrypt and check round-trip PT_out == PT_in
  task automatic run_enc_dec_roundtrip(
    string        name,
    logic [127:0] pt
  );
    logic [127:0] ct_tmp;

    $display("[%0t] --- Round-trip test: %s ---", $time, name);

    // -------- Encrypt --------
    plain_text_in = pt;

    @(posedge clk);
    @(posedge clk);

    start_enc = 1'b1;
    @(posedge clk);
    start_enc = 1'b0;

    @(posedge done_enc);
    #1;
    ct_tmp = cipher_text_out;
    $display("[%0t]   Encrypted CT = %032h", $time, ct_tmp);

    // -------- Decrypt --------
    cipher_text_in = ct_tmp;

    @(posedge clk);
    @(posedge clk);
    
    start_dec = 1'b1;
    @(posedge clk);
    start_dec = 1'b0;

    @(posedge done_dec);
    #1;

    check_equal({name, " round-trip plain check"}, plain_text_out, pt);
  endtask

  // ---------------------------------
  // Test sequence
  // ---------------------------------
  initial begin
    // Init
    reset_n     = 1'b0;
    start_enc   = 1'b0;
    start_dec   = 1'b0;
    set_new_key = 1'b0;
    key_in      = '0;
    plain_text_in  = '0;
    cipher_text_in = '0;

    $display("=== tb_decryption start ===");

    // Reset
    wait_posedges(2);
    reset_n = 1'b1;
    wait_posedges(2);

    // -------------------------------
    // Use FIPS-197 example key/vector
    // Key:        2b7e151628aed2a6abf7158809cf4f3c
    // Plaintext:  3243f6a8885a308d313198a2e0370734
    // Ciphertext: 3925841d02dc09fbdc118597196a0b32
    // -------------------------------
    load_key("FIPS-197 key",
             128'h2b7e151628aed2a6abf7158809cf4f3c);

    // 1) Encryption-only KAT
    run_encrypt_test(
      "FIPS-197 Enc",
      128'h3243f6a8885a308d313198a2e0370734,
      128'h3925841d02dc09fbdc118597196a0b32
    );

    // 2) Decryption-only KAT (direct ciphertext → plaintext)
    run_decrypt_test(
      "FIPS-197 Dec",
      128'h3925841d02dc09fbdc118597196a0b32,
      128'h3243f6a8885a308d313198a2e0370734
    );

    // 3) Round-trip PT → Enc → Dec → PT
    run_enc_dec_roundtrip(
      "Round-trip 1",
      128'h3243f6a8885a308d313198a2e0370734
    );

    // 4) Optional extra round-trip with a different PT
    run_enc_dec_roundtrip(
      "Round-trip 2 (pattern)",
      128'h00112233445566778899aabbccddeeff
    );

    // ---------------------------------
    // Summary
    // ---------------------------------
    $display("=== tb_decryption summary ===");
    $display("  PASSED: %0d", pass_count);
    $display("  FAILED: %0d", fail_count);

    if (fail_count == 0)
      $display("All tests PASSED ✅");
    else
      $display("Some tests FAILED ❌");

    $display("=== tb_decryption done ===");
    #50;
    $finish;
  end

endmodule
