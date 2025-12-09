module tb_decryption;
timeunit 1ns/1ps;

logic [127:0] plain_text_in, plain_text_out;
logic [127:0] key_in, key_dec, key_enc;
logic clk;
logic reset_n;
logic start_enc, start_dec;
logic done_dec, done_enc;
logic set_new_key;
logic [127:0] cipher_text_in, cipher_text_out;

decryption dut(
    .clk(clk),
    .plain_text(plain_text_out),
    .key_in(key_dec),
    .reset_n(reset_n),
    .start(start_dec),
    .cipher_text(cipher_text_in),
    .ready_dec(ready_dec),
    .done_dec(done_dec)
);

encryption encryption(
    .clk(clk),
    .plain_text(plain_text_in),
    .key_in(key_enc),
    .reset_n(reset_n),
    .start(start_enc),
    .cipher_text(cipher_text_out),
    .ready_enc(ready_enc),
    .done_enc(done_enc)
);

key_expansion key_expansion_unit(
    .set_new_key (set_new_key),
    .key_in      (key_in),
    .start_enc   (start_enc),
    .ready_enc   (ready_enc),
    .key_enc     (key_enc),
    .start_dec   (start_dec),
    .ready_dec   (ready_dec),
    .key_dec     (key_dec)
);

initial begin
    $dumpfile("dump.vcd");  
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
    #6;
    set_new_key =1'b1;
    key_in = 128'h2b7e151628aed2a6abf7158809cf4f3c;
    #10;
    set_new_key =1'b0;

    plain_text_in = 128'h3243f6a8885a308d313198a2e0370734;
    
    reset_n = 1'b1;
    start_enc = 1'b0;

    #10;
    reset_n = 1'b0;
    #10;
    reset_n = 1'b1;
    #10;
    start_enc = 1;
    #10;
    start_enc = 0;

    @(negedge done_enc);
    check_output(cipher_text_out, 128'h3925841d02dc09fbdc118597196a0b32);

    #10;
    @(posedge clk);

    cipher_text_in = 128'h3925841d02dc09fbdc118597196a0b32;
    
    reset_n = 1'b1;
    start_dec = 1'b0;
    #10;
    reset_n = 1'b0;
    #10;
    reset_n = 1'b1;
    #10;
    start_dec = 1;
    #10;
    start_dec = 0;

    @(negedge done_dec);
    check_output(plain_text_out, 128'h3243f6a8885a308d313198a2e0370734);
    #500;
$finish;

end
endmodule
