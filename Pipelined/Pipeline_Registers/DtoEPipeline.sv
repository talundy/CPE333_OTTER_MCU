`timescale 1ps/1ps

module DtoE (
    input CLK,
    input RegWriteD, 
    input [1:0] ResultSrcD,
    input MemWriteD,
    input JumpD, 
    input BranchD, 
    input [4:0] ALUControlD, 
    input ALUSrcD, 
    input [31:0] RD1,
    input [31:0] RD2, 
    input [31:0] PCD, 
    input [4:0] RdD, 
    input [31:0] ImmExtD, 
    input [31:0] PCPlus4D,
    input MemSignD,
    input [1:0] MemSizeD,

    output logic RegWriteE,
    output logic [1:0] ResultSrcE,
    output logic MemWriteE,
    output logic JumpE,
    output logic BranchE,
    output logic [4:0] ALUControlE,
    output logic ALUSrcE,
    output logic [31:0] RD1E,
    output logic [31:0] RD2E,
    output logic [31:0] PCE, 
    output logic [4:0] RdE, 
    output logic [31:0] ImmExtE,
    output logic [31:0] PCPlus4E,
    output logic MemSignE,
    output logic [1:0] MemSizeE

); 

    always_ff @ (posedge CLK) begin
        RegWriteE <= RegWriteD;
        ResultSrcE <= ResultSrcD;
        MemWriteE <= MemWriteD;
        JumpE <= JumpD;
        BranchE <= BranchD;
        ALUControlE <= ALUControlD;
        ALUSrcE <= ALUSrcD;
        RD1E <= RD1;
        RD2E <= RD2;
        PCE <= PCD;
        RdE <= RdD;
        ImmExtE <= ImmExtD;
        PCPlus4E <= PCPlus4D;    
        MemSignE <= MemSignD;
        MemSizeE <= MemSizeD;
    end
endmodule