module aes_core (
    input clk, reset_n,
    input set_plain_text,
    input logic [127:0] plain_text_in, 
    output logic [127:0] plain_text_out,
    input set_cipher_text,
    input logic [127:0] cipher_text_in, 
    output logic [127:0] cipher_text_out,
    input set_key,
    input logic [127:0] key, 
    input start_enc, start_dec
);

timeunit 1ns/1ps;

logic [127:0] key_out, key_enc, key_dec;

logic [127:0] plain_text_reg_in, plain_text_reg_out, cipher_text_reg_in, cipher_text_reg_out, cipher_text, plain_text;

dff reg_plain_text(
    .clk(clk),
    .reset_n(reset_n),
    .en(set_plain_text | done_dec), //done from dec should and here
    .d(plain_text_reg_in),
    .q(plain_text_reg_out)
);

dff reg_cipher_text(
    .clk(clk),
    .reset_n(reset_n),
    .en(set_cipher_text  | done_enc), //done from enc should and here
    .d(cipher_text_reg_in),
    .q(cipher_text_reg_out)
);

dff reg_key(
    .clk(clk),
    .reset_n(reset_n),
    .en(set_key),
    .d(key),
    .q(key_out)
);

mux2to1 plain_text_reg_input(
    .a(plain_text),
    .b(plain_text_in),
    .sel(set_plain_text),
    .y(plain_text_reg_in)
);

mux2to1 cipher_text_reg_input(
    .a(cipher_text),
    .b(cipher_text_in),
    .sel(set_cipher_text),
    .y(cipher_text_reg_in)
);

encryption encryption_unit(
    .clk(clk),
    .reset_n(reset_n),
    .start(start_enc),
    .plain_text(plain_text_reg_out),
    .key_in(key_enc),
    .ready_enc(ready_enc),
    .cipher_text(cipher_text),
    .done_enc(done_enc)
);

decryption decryption_unit(
    .clk(clk),
    .reset_n(reset_n),
    .start(start_dec),
    .cipher_text(cipher_text_reg_out),
    .key_in(key_dec),
    .ready_dec(ready_dec),
    .plain_text(plain_text),
    .done_dec(done_dec)
);

key_expansion key_expansion_unit(
    .set_new_key (start_enc),
    .key_in      (key_out),
    .start_enc   (start_enc),
    .ready_enc   (ready_enc),
    .key_enc     (key_enc),
    .start_dec   (start_dec),
    .ready_dec   (ready_dec),
    .key_dec     (key_dec)
);

assign cipher_text_out = cipher_text_reg_out;
assign plain_text_out = plain_text_reg_out;
    
endmodule
