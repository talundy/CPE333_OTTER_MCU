`timescale 1ps/1ps

module EtoM(
    input CLK,
    input RegWriteE,
    input [1:0] ResultSrcE,
    input MemWriteE,
    input [31:0] ALUResultE,
    input [31:0] WriteDataE,
    input [4:0] RdE,
    input [31:0] PCPlus4E,
    input [1:0] MemSizeE,
    input MemSignE,

    output logic RegWriteM,
    output logic [1:0] ResultSrcM,
    output logic MemWriteM,
    output logic [31:0] ALUResultM,
    output logic [31:0] WriteDataM,
    output logic [4:0] RdM,
    output logic [31:0] PCPlus4M,
    output logic [1:0] MemSizeM,
    output logic MemSignM
);

    always_ff @ (posedge CLK) begin
        RegWriteM <= RegWriteE;
        ResultSrcM <= ResultSrcE;
        MemWriteM <= MemWriteE;
        ALUResultM <= ALUResultE;
        WriteDataM <= WriteDataE;
        RdM <= RdE;
        PCPlus4M <= PCPlus4E;
        MemSizeM <= MemSizeE;
        MemSignM <= MemSignE;
    end

endmodule