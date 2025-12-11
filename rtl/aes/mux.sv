module mux2to1 (
    input logic [127:0] a,
    input logic [127:0] b,
    input logic sel,
    output logic [127:0] y
);
timeunit 1ns/1ps;
assign y = sel? b : a;


endmodule
