module sub_bytes (
	input  logic        clk,
	input  logic        enable,
	input  logic [127:0] in,
	output logic [127:0] out,
	output logic sub_ready
);
timeunit 1ns/1ps;
	logic [127:0] out_comb; 

	genvar i;
	generate
		for (i = 0; i < 16; i++) begin : gen_sbox
			s_box u_s_box (
				.in (in [8*i +: 8]),
				.out(out_comb[8*i +: 8])
			);
		end
	endgenerate

    
    always_ff @(posedge clk) begin
		if (enable) begin
			out <= out_comb;
			sub_ready <= 1'b1;
		end
		else begin
			out <= 128'd0;
			sub_ready <= 1'b0;
		end

    end

endmodule




