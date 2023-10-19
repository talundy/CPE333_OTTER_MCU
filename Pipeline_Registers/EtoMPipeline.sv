`timescale 1ps/1ps

module EtoMPipeline(
    input CLK,
    input RegWriteE,
    input [1:0] RegSrcE,
    input MemWriteE,
    input ALUResultE,
    input WriteDataE,
    input DCImmAdd,
    input PCPlus4E,

    output logic RegWriteM,
    output [1:0] logic ResultSrcM,
    output logic MemWriteM,
    output logic ALUResultM,
    output logic WriteDataM,
    output logic RdM,
    output logic PCPlus4M
);

always_ff @ (posedge CLK)
    begin
        RegWriteE <= RegWriteM;
        RegSrcE <= ResultSrcM;
        MemWriteE <= MemWriteM;
        ALUResultE <= ALUResultM;
        WriteDataE <= WriteDataM;
        DCImmAdd <= RdM;
        PCPlus4E <= PCPlus4M;
    end

endmodule