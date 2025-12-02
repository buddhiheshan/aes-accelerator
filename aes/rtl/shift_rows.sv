module shift_rows #(
    parameter logic INVERSE = 1'b0
)(
    input  logic [127:0] input_state,
    output logic [127:0] output_state
);
    // Byte arrays (column-major: index = 4*col + row)
    logic [7:0] s [0:15];
    logic [7:0] t [0:15];

    genvar i;

    // --------------------------------------------------------
    // UNPACK: Convert 128-bit input to byte array
    // FIXED: Reads from MSB (127) down to LSB (0) so 128'h inputs work correctly
    // --------------------------------------------------------
    generate
        for (i = 0; i < 16; i++) begin : UNPACK
            // "127 - (8*i)" points to the top bit of the current byte
            // "-: 8" grabs that bit and the 7 bits below it
            assign s[i] = input_state[127 - (8*i) -: 8];
        end
    endgenerate

    // --------------------------------------------------------
    // SHIFT LOGIC: Permute the bytes
    // --------------------------------------------------------
    generate
        if (!INVERSE) begin : Encryption
            // ShiftRows: Left Shift
            
            // Row 0 (No Shift)
            assign t[0]  = s[0];   assign t[4]  = s[4];   assign t[8]  = s[8];   assign t[12] = s[12];
            
            // Row 1 (Left 1)
            // moves s[5] (col 1) to t[1] (col 0)
            assign t[1]  = s[5];   assign t[5]  = s[9];   assign t[9]  = s[13];  assign t[13] = s[1];
            
            // Row 2 (Left 2)
            assign t[2]  = s[10];  assign t[6]  = s[14];  assign t[10] = s[2];   assign t[14] = s[6];
            
            // Row 3 (Left 3)
            assign t[3]  = s[15];  assign t[7]  = s[3];   assign t[11] = s[7];   assign t[15] = s[11];
        end
        else begin : Decryption
            // InvShiftRows: Right Shift
            
            // Row 0 (No Shift)
            assign t[0]  = s[0];   assign t[4]  = s[4];   assign t[8]  = s[8];   assign t[12] = s[12];
            
            // Row 1 (Right 1)
            assign t[1]  = s[13];  assign t[5]  = s[1];   assign t[9]  = s[5];   assign t[13] = s[9];
            
            // Row 2 (Right 2)
            assign t[2]  = s[10];  assign t[6]  = s[14];  assign t[10] = s[2];   assign t[14] = s[6];
            
            // Row 3 (Right 3)
            assign t[3]  = s[7];   assign t[7]  = s[11];  assign t[11] = s[15];  assign t[15] = s[3];
        end
    endgenerate

    // --------------------------------------------------------
    // PACK: Convert byte array back to 128-bit output
    // FIXED: Writes from MSB (127) down to LSB (0)
    // --------------------------------------------------------
    generate
        for (i = 0; i < 16; i++) begin : PACK
            assign output_state[127 - (8*i) -: 8] = t[i];
        end
    endgenerate

endmodule
