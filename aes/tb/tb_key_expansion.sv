
module tb_key_expansion_readypulse_print_simple;
  timeunit 1ns/1ps;

  logic         ready  = 1'b0;
  logic [127:0] key_in = 128'h000102030405060708090A0B0C0D0E0F; // example key

  // DUT outputs
  logic  [3:0]  index;
  logic [127:0] round_key;

  key_expansion dut (
    .ready(ready), 
    .key_in(key_in),
    .index(index), 
    .round_key(round_key)
  );

  // Optional waves
  initial begin
    $fsdbDumpfile("dump.fsdb");  
    $fsdbDumpvars;
  end

  // Drive 11 pulses and print each key
  integer i;
  initial begin
    $display("Start: printing K0..K10");
    for (i = 0; i < 11; i = i + 1) begin
      // idle gap
      #10;

      // make a clean pulse
      ready = 1'b1;

      // small delay to let comb paths settle (DUT drives on ready=1)
      #1;

      // print while ready is high (index/round_key valid only now)
      $display("[%0t] index=%0d  round_key=%032h", $time, index, round_key);
      #1;
      // deassert ready; outputs go to 0 between pulses
      ready = 1'b0;
      
    end

    $display("Done: printed K0..K10");
    #10 
    $finish;
  end

endmodule
