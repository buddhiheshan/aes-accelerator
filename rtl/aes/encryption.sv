module encryption (
    input logic [127:0] plain_text,
    input logic [127:0] key_in,
    input logic clk,
    input logic reset_n,
    input logic start,
    output logic ready_enc,
    output logic [127:0] cipher_text,
    output logic done_enc
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

logic [127:0] final_cipher;         // wire after second add round key module
logic done;


mux2to1 initial_mux (
    .a(plain_text),
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

sub_bytes sub_bytes(
    .in(after_2_pipe),
    .out(after_sub_bytes)
);

shift_rows shift_rows(
    .input_state(after_sub_bytes),
    .output_state(after_shift_rows)
);

pipeline_reg third_register(
    .d(after_shift_rows),
    .clk(clk),
    .reset_n(reset_n),
    .q(after_3_pipe)
);


mix_cols mix_columns(
    .input_state(after_3_pipe),
    .output_state(after_mc)
);


encryption_fsm encryption_fsm(
    .clk(clk),
    .reset_n(reset_n),
    .start(start),
    .mux_sel(mux_sel),
    .req_key(ready_enc),
    .done(done_enc)
);

add_roundkey final_add_round_key(
    .input_state(after_3_pipe),
    .key(key_in),
    .output_state(cipher_text)
);

// dff reg_cipher_text(
//     .clk(clk),
//     .reset_n(reset_n),
//     .en(done),
//     .d(final_cipher),
//     .q(cipher_text)
// );


// assign cipher_text = done? final_cipher : 128'd0;


endmodule
