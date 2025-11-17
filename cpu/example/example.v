module mux4to1 (
    // Standard Combinational Mux Inputs
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [1:0] sel,

    // Synchronous Signals
    input clk,
    input resetn, // Synchronous or Asynchronous Reset

    // Registered Output
    output reg [3:0] out
);

    // 1. Define the combinational logic for the Mux
    // This intermediate wire will update instantly
    wire [3:0] mux_result;

    assign mux_result = sel[1] ? (sel[0] ? d : c) : (sel[0] ? b : a);

    // 2. Register the output
    // The output 'out' only changes on the positive edge of the clock (posedge clk)
    always @(posedge clk) begin
        if (resetn) begin
            // Reset state (good practice)
            out <= 4'b0000;
        end else begin
            // Register the combinational result
            out <= mux_result;
        end
    end

endmodule
