module tb_top_encryption;
timeunit 1ns/1ps;

logic [127:0] plain_text;
logic [127:0] key_in;
logic clk;
logic reset_n;
logic start;
logic restart;
logic [127:0] cipher_text;


top_encryption dut(
    .clk(clk),
    .plain_text(plain_text),
    .key_in(key_in),
    .reset_n(reset_n),
    .start(start),
    .restart(restart),
    .cipher_text(cipher_text)
);

initial begin
    $fsdbDumpfile("dump.fsdb");  
    $fsdbDumpvars;
  end

always #5 clk = ~clk;



initial begin
    clk = 1'b1;
    plain_text = 128'h89c2abb23688ac1c675eb2d4cf2a263e;
key_in = 128'h000102030405060708090A0B0C0D0E0F;
reset_n = 1'b1;
start = 1'b0;
restart = 1'b0;
    #10;
    reset_n = 1'b0;
    #10;
    reset_n = 1'b1;
    #10;
start = 1;
#350;
$finish;

end
endmodule
