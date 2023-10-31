`timescale 1ns/1ps

module Mux2(
    input Src,
    input [31:0] Arg0,
    input [31:0] Arg1,
    output logic [31:0] Result
);
    always_comb begin
        case(Src)
            1'b0: Result = Arg0;
            1'b1: Result = Arg1;
            default: Result = 32'd0;
        endcase
    end


endmodule


module Mux4(
    input [1:0] Src,
    input [31:0] Arg0,
    input [31:0] Arg1,
    input [31:0] Arg2,
    input [31:0] Arg3,
    output logic [31:0] Result
);
    always_comb begin
        case(Src)
            2'b00: Result = Arg0;
            2'b01: Result = Arg1;
            2'b10: Result = Arg2;
            2'b11: Result = Arg3;
            default: Result = 32'd0;
        endcase
    end

endmodule

module Mux8(
    input [2:0] Src,
    input [31:0] Arg0,
    input [31:0] Arg1,
    input [31:0] Arg2,
    input [31:0] Arg3,
    input [31:0] Arg4,
    input [31:0] Arg5,
    input [31:0] Arg6,
    input [31:0] Arg7,
    output logic [31:0] Result
);

    always_comb begin
        case(Src)
            3'b000: Result = Arg0;
            3'b001: Result = Arg1;
            3'b010: Result = Arg2;
            3'b011: Result = Arg3;
            3'b100: Result = Arg4;
            3'b101: Result = Arg5;
            3'b110: Result = Arg6;
            3'b111: Result = Arg7;
            default: Result = 32'd0;
        endcase
    end
endmodule