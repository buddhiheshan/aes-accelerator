module sub_bytes (
  input  logic [127:0] in,
  output logic [127:0] out
);

  timeunit 1ns/1ps;

  // 16 parallel S-boxes, each processing one byte

  genvar i;
  generate
    for (i = 0; i < 16; i++) begin : gen_sbox
      s_box u_s_box (
        .in  ( in [8*i +: 8] ),
        .out ( out[8*i +: 8] )
      );
    end
  endgenerate
	
endmodule


