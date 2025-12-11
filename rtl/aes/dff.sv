module dff #(
    parameter int WIDTH = 128
) (
    input  logic                 clk,
    input  logic                 reset_n,   // active-low reset
    input  logic                 en,        // enable
    input  logic [WIDTH-1:0]     d,
    output logic [WIDTH-1:0]     q
);

    always_ff @(posedge clk) begin
        if (!reset_n)
            q <= '0;              // reset to all zeros
        else if (en)
            q <= d;               // latch new value only when enable = 1
        // else: hold previous q
    end

endmodule
