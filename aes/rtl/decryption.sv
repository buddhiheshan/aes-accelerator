module decryption (
    output logic [127:0] plain_text,
    input logic [127:0] key_in,
    input logic clk,
    input logic reset_n,
    input logic start,
    output logic ready_dec,
    input logic [127:0] cipher_text,
    output logic done_dec
);
timeunit 1ns/1ps;

logic [127:0] after_mc;             // wire after mix columns
logic mux_sel;                      // wire for mux select from encryption_fsm
logic [127:0] after_mux;            // wire after mux operation
logic [127:0] after_1_pipe;         // wire after 1st pipeline register
       
logic [127:0] after_ark;            // wire after add round key

logic [127:0] after_2_pipe;         // wire after 2nd pipeline register

logic [127:0] after_sub_bytes;      // wire after sub_bytes module
logic [127:0] after_shift_rows;     // wire after shift_rows;

logic [127:0] after_3_pipe;         // wire after 3rd pipeline register

logic ready_fsm;                    // ready signal from encryption_fsm ----- the control module

logic done;

mux2to1 initial_mux (
    .a(cipher_text),
    .b(after_mc),
    .sel(mux_sel),
    .y(after_mux)
);

pipeline_reg first_register(
    .d(after_mux),
    .clk(clk),
    .reset_n(reset_n),
    .q(after_1_pipe)
);

add_roundkey add_round_key(
    .input_state(after_1_pipe),
    .key(key_in),
    .output_state(after_ark)
);

pipeline_reg second_register(
    .d(after_ark),
    .clk(clk),
    .reset_n(reset_n),
    .q(after_2_pipe)
);

shift_rows #(.INVERSE(1)) shift_rows_inv(
    .input_state(after_2_pipe),
    .output_state(after_shift_rows)
);

sub_bytes_inv sub_bytes_inv(
    .in(after_shift_rows),
    .out(after_sub_bytes)
);

pipeline_reg third_register(
    .d(after_sub_bytes),
    .clk(clk),
    .reset_n(reset_n),
    .q(after_3_pipe)
);

mix_cols #(.INVERSE(1)) mix_columns_inv(
    .input_state(after_3_pipe),
    .output_state(after_mc)
);

add_roundkey final_add_round_key(
    .input_state(after_3_pipe),
    .key(key_in),
    .output_state(plain_text)
);

decryption_fsm decryption_fsm(
    .clk(clk),
    .reset_n(reset_n),
    .start(start),
    .mux_sel(mux_sel),
    .req_key(ready_dec),
    .done(done_dec)
);
endmodule
