`timescale 1ps/1ps

module MtoW(
    input CLK,
    input RegWriteM,
    input [1:0] ResultSrcM,
    input [31:0] ALUResultM,
    input [31:0] ReadDataM,
    input [4:0] RdM,
    input [31:0] PCPlus4M,

    output logic RegWriteW,
    output logic [1:0] ResultSrcW,
    output logic [31:0] ALUResultW,
    output logic [31:0] ReadDataW,
    output logic [4:0] RdW,
    output logic [31:0] PCPlus4W 
);

always_ff @ (posedge CLK)
    begin
        RegWriteW <= RegWriteM;
        ResultSrcW <= ResultSrcM;
        ALUResultW <= ALUResultM;
        ReadDataW <= ReadDataM;
        RdW <= RdM;
        PCPlus4W <= PCPlus4M;
    end

endmodule