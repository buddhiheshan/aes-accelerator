module tb_aes_core;
timeunit 1ns/1ps;

logic [127:0] plain_text_in, plain_text_out;
logic [127:0] key_in;
logic clk;
logic reset_n;
logic set_plain_text;
logic set_cipher_text;
logic set_new_key;
logic start_enc, start_dec, done_dec, done_enc;
logic [127:0] cipher_text_in, cipher_text_out;

aes_core dut(
    .clk(clk), 
    .reset_n(reset_n),
    .set_plain_text(set_plain_text),
    .plain_text_in(plain_text_in),
    .plain_text_out(plain_text_out),
    .set_cipher_text(set_cipher_text),
    .cipher_text_in(cipher_text_in),
    .cipher_text_out(cipher_text_out),
    .set_key(set_new_key),
    .key(key_in),
    .start_enc(start_enc),
    .start_dec(start_dec),
    .done_enc(done_enc),
    .done_dec(done_dec)
);

initial begin
    $dumpfile("aes_core.vcd");  
    $dumpvars;
  end

always #5 clk = ~clk;

task check_output(logic [127:0] output_state, logic [127:0] expected_output_state);
        if (output_state !== expected_output_state) begin
            $display("FAILED: Output state missmatch!");
            $display("Expected: %h\nGot: %h", expected_output_state, output_state);
        end
        else $display("PASS");
endtask

initial begin
    clk = 1'b1;
    reset_n = 1'b1;
    start_enc = 1'b0;
    start_dec = 1'b0;
    set_plain_text = 1'b0;
    set_cipher_text = 1'b0;
    
    @(negedge clk);
    reset_n = 1'b0;

    @(negedge clk);
    reset_n = 1'b1;
    
    @(negedge clk);
    set_new_key =1'b1;
    key_in = 128'h2b7e151628aed2a6abf7158809cf4f3c;
    
    @(negedge clk);
    set_new_key =1'b0;

    set_plain_text = 1'b1;
    plain_text_in = 128'h3243f6a8885a308d313198a2e0370734;

    @(negedge clk);
    set_plain_text = 1'b0;
    
    @(negedge clk);
    @(negedge clk);
    start_enc = 1'b1;

    @(negedge clk);
    start_enc = 1'b0;
    
    #500;
    check_output(cipher_text_out, 128'h3925841d02dc09fbdc118597196a0b32);

    @(negedge clk);
    start_enc = 1'b1;

    @(negedge clk);
    @(negedge clk);
    start_enc = 1'b0;
    check_output(plain_text_out, 128'h3243f6a8885a308d313198a2e0370734);

$finish;

end
endmodule
