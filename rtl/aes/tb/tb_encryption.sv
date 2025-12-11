`timescale 1ns/1ps

module tb_encryption;
  timeunit 1ns/1ps;

  // -----------------------------
  // DUT signals
  // -----------------------------
  logic        clk;
  logic        reset_n;

  logic [127:0] plain_text;
  logic [127:0] key_in;
  logic [127:0] key_enc;
  logic [127:0] cipher_text;

  logic        start;
  logic        set_new_key;
  logic        ready_enc;
  logic        done_enc;

  int pass_count = 0;
  int fail_count = 0;

  // -----------------------------
  // DUT Instantiations
  // -----------------------------
  encryption dut (
    .clk        (clk),
    .plain_text (plain_text),
    .key_in     (key_enc),
    .reset_n    (reset_n),
    .start      (start),
    .cipher_text(cipher_text),
    .ready_enc  (ready_enc),
    .done_enc   (done_enc)
  );

  key_expansion key_expansion_unit (
    .set_new_key (set_new_key),
    .key_in      (key_in),
    .start_enc   (start),
    .ready_enc   (ready_enc),
    .key_enc     (key_enc),
    .start_dec   (),
    .ready_dec   (),
    .key_dec     ()
  );

  // -----------------------------
  // Clock
  // -----------------------------
  initial clk = 1'b0;
  always  #5 clk = ~clk; // 100 MHz

  // -----------------------------
  // Waves
  // -----------------------------
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_encryption);
  end

  // -----------------------------
  // Utility tasks
  // -----------------------------
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

  // Wait for N posedges of clk
  task automatic wait_posedges(int n);
    repeat (n) @(posedge clk);
  endtask

  // Load a new key via key_expansion and wait until ready_enc is 1
  task automatic load_key(
    string        name,
    logic [127:0] new_key
  );
    $display("[%0t] --- Loading key: %s ---", $time, name);
    set_new_key = 1'b1;
    key_in      = new_key;

    // Give key_expansion at least one cycle to see set_new_key
    wait_posedges(1);
    set_new_key = 1'b0;

    // Wait until ready_enc is asserted (key schedule ready / core idle)
    $display("[%0t] Key load done (ready_enc=1)", $time);
  endtask

  // Run a single encryption test: assumes key already loaded
  task automatic run_encrypt_test(
    string        name,
    logic [127:0] pt,
    logic [127:0] expected_ct
  );
    $display("[%0t] --- Starting encryption test: %s ---", $time, name);

    // Drive plaintext
    plain_text = pt;

    @(posedge clk);
    @(posedge clk);

    // Pulse start for one cycle
    start = 1'b1;
    @(posedge clk);
    start = 1'b0;

    // Wait for encryption to complete
    @(negedge done_enc); // assuming done_enc pulses high when done
    #1; // small delta to sample cipher_text

    check_equal({name, " cipher check"}, cipher_text, expected_ct);
  endtask

  // -----------------------------
  // Test sequence
  // -----------------------------
  initial begin
    // Default init
    clk         = 1'b0;
    reset_n     = 1'b0;
    start       = 1'b0;
    set_new_key = 1'b0;
    plain_text  = '0;
    key_in      = '0;

    $display("=== tb_encryption start ===");

    // Apply reset
    wait_posedges(2);
    reset_n = 1'b1;
    wait_posedges(2);

    // -------------------------
    // Test 1: FIPS-197 example
    // Key:        2b7e151628aed2a6abf7158809cf4f3c
    // Plaintext:  3243f6a8885a308d313198a2e0370734
    // Ciphertext: 3925841d02dc09fbdc118597196a0b32
    // -------------------------
    load_key("FIPS key #1",
             128'h2b7e151628aed2a6abf7158809cf4f3c);

    run_encrypt_test(
      "FIPS-197 Example #1",
      128'h3243f6a8885a308d313198a2e0370734,
      128'h3925841d02dc09fbdc118597196a0b32
    );

    // -------------------------
    // (Optional) Test 2: same key, different plaintext
    // Add more known-answer tests if you have them
    // -------------------------
    // Example with a made-up plaintext & expected (fill in once you know):
    run_encrypt_test(
      "Test 2: Same key, new plaintext",
      128'h00112233445566778899aabbccddeeff,
      128'h8df4e9aac5c7573a27d8d055d6e4d64b
    );

    // -------------------------
    // (Optional) Test 3: load another key
    // -------------------------
    load_key("FIPS key #2",
             128'h000102030405060708090a0b0c0d0e0f);
    
    run_encrypt_test(
      "FIPS-197 Example #2",
      128'h00112233445566778899aabbccddeeff,
      128'h69c4e0d86a7b0430d8cdb78070b4c55a
    );

    // -------------------------
    // Summary
    // -------------------------
    $display("=== tb_encryption summary ===");
    $display("  PASSED: %0d", pass_count);
    $display("  FAILED: %0d", fail_count);

    if (fail_count == 0)
      $display("All tests PASSED ✅");
    else
      $display("Some tests FAILED ❌");

    $display("=== tb_encryption done ===");
    #50;
    $finish;
  end

endmodule
