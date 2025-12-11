module add_roundkey (
    input logic [127:0] input_state,
    input logic [127:0] key,
    output logic [127:0] output_state
);

assign output_state = input_state ^ key;
    
endmodule
