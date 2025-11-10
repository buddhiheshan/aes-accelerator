module pipeline_reg (
    input logic [127:0] d,
    input logic clk,
    input logic reset_n,
    output logic [127:0] q
);

always_ff @( posedge clk ) begin
    if (!reset_n) begin
        q <= 128'b0;
    end
    else begin
        q <= d;
    end
end

endmodule
