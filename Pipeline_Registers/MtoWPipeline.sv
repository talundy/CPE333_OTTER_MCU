`timescale 1ps/1ps

module MtoPipeline(
    input CLK,
    input RegWriteM,
    input [1:0] ResultSrcM,
    input ALUResultM,
    input ReadDataM,
    input RdM,
    input PCPlus4M,

    output logic RegWriteW,
    output [1:0] logic ResultSrcW,
    output ALUResultW,
    output ReadDataW,
    output RdW,
    output PCPlus4W 
);

always_ff @ (posedge CLK)
    begin
        RegWriteM <= RegWriteW;
        ResultSrcM <= ResultSrcW;
        ALUResultM <= ALUResultW,
        ReadDataM <= ReadDataW;
        RdM <= RdW,
        PCPlus4M <= PCPlus4W
    end

endmodule