module shift_rows (
    input  logic [127:0] input_state,
    output logic [127:0] output_state
);
    // TODO: 

    // Byte arrays (column-major: index = 4*col + row)
    logic [7:0] s [0:15];
    logic [7:0] t [0:15];

    // Unpack input_state into bytes
    genvar i;
    generate
        for (i = 0; i < 16; i++) begin : UNPACK
        assign s[i] = input_state[8*i +: 8];
        end
    endgenerate

    // ShiftRows mapping (encryption)
    // Row 0
    assign t[0]  = s[0];   assign t[4]  = s[4];   assign t[8]  = s[8];   assign t[12] = s[12];
    // Row 1
    assign t[1]  = s[5];   assign t[5]  = s[9];   assign t[9]  = s[13];  assign t[13] = s[1];
    // Row 2
    assign t[2]  = s[10];  assign t[6]  = s[14];  assign t[10] = s[2];   assign t[14] = s[6];
    // Row 3
    assign t[3]  = s[15];  assign t[7]  = s[3];   assign t[11] = s[7];   assign t[15] = s[11];

    // Re-pack bytes to output_state
    generate
        for (i = 0; i < 16; i++) begin : PACK
        assign output_state[8*i +: 8] = t[i];
        end
    endgenerate

endmodule
