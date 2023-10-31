`timescale 1ns/1ps

module Adder(
    input [31:0] SrcA,
    input [31:0] SrcB,
    output [31:0] Result
);

    assign Result = SrcA + SrcB;

endmodule