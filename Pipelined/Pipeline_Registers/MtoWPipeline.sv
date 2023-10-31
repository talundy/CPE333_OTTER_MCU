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
    output logic [1:0] ResultSrcW,
    output logic ALUResultW,
    output logic ReadDataW,
    output logic RdW,
    output logic PCPlus4W 
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