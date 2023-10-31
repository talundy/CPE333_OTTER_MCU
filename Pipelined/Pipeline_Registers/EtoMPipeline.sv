`timescale 1ps/1ps

module EtoMPipeline(
    input CLK,
    input RegWriteE,
    input [1:0] RegSrcE,
    input MemWriteE,
    input ALUResultE,
    input RD2E,
    input RdE,
    input PCPlus4E,
    input [1:0] MemSizeE,
    input MemSignE,

    output logic RegWriteM,
    output logic [1:0] ResultSrcM,
    output logic MemWriteM,
    output logic ALUResultM,
    output logic WriteDataM,
    output logic RdM,
    output logic PCPlus4M,
    output logic [1:0] MemSizeM,
    output logic MemSignM
);

    always_ff @ (posedge CLK) begin
        RegWriteM <= RegWriteE;
        RegSrcM <= ResultSrcE;
        MemWriteM <= MemWriteE;
        ALUResultM <= ALUResultE;
        WriteDataM <= RD2E;
        RdM <= RdE;
        PCPlus4M <= PCPlus4E;
        MemSizeM <= MemSizeE;
        MemSignM <= MemSignE;
    end

endmodule