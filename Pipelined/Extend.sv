`timescale 1ns/1ps

module Extend(
    input [24:0] Imm,
    input [2:0] ImmSrc,
    output logic [31:0] ImmExt
);

    always_comb begin
        case(ImmSrc)
            1: ImmExt = {{21{Imm[24]}}, Imm[23:13]}; // I-type
            2: ImmExt = {{21{Imm[24]}}, Imm[23:18], Imm[4:0]}; // S-type
            3: ImmExt = {{20{Imm[24]}}, Imm[0], Imm[23:18], Imm[4:1], 1'b0}; // B-type
            4: ImmExt = {Imm[24:5], 12'h000}; // U-type
            5: ImmExt = {{12{Imm[24]}}, Imm[12:5], Imm[13], Imm[23:14], 1'b0}; // J-type
        endcase
    end

endmodule