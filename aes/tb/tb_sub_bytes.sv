module tb_sub_bytes;
  timeunit 1ns/1ps;

  // DUT I/O
  logic [127:0] sb_in;
  logic [127:0] sb_out;

  // DUT (purely combinational)
  sub_bytes u_sub_bytes (
    .in  (sb_in),
    .out (sb_out)
  );

  // Waves (optional)
  initial begin
    $fsdbDumpfile("dump.fsdb");
    $fsdbDumpvars;
  end

  initial begin
    $display("=== Start tb_sub_bytes (purely combinational) ===");

    // Vec 1: 00..0F (LSB is byte 0)
    sb_in = 128'h0f0e0d0c0b0a09080706050403020100;
    #1; // allow comb propagation
    $display("Vec1 sb_in  = 0x%032h", sb_in);
    $display("Vec1 sb_out = 0x%032h", sb_out);

    // Vec 2: all zeros
    sb_in = 128'h00000000000000000000000000000000;
    #1;
    $display("Vec2 sb_in  = 0x%032h", sb_in);
    $display("Vec2 sb_out = 0x%032h", sb_out);

    // Vec 3: all FF
    sb_in = 128'hffffffffffffffffffffffffffffffff;
    #1;
    $display("Vec3 sb_in  = 0x%032h", sb_in);
    $display("Vec3 sb_out = 0x%032h", sb_out);

    // Vec 4: pattern
    sb_in = 128'h00112233445566778899aabbccddeeff;
    #1;
    $display("Vec4 sb_in  = 0x%032h", sb_in);
    $display("Vec4 sb_out = 0x%032h", sb_out);

    $display("=== Done ===");
    $finish;
  end

endmodule
