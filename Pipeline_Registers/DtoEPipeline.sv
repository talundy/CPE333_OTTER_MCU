`timescale 1ps/1ps

module DtoEPipeline (
    input CLK,
    input RegWriteD, 
    input [1:0] ResultSrcD,
    input MemWriteD,
    input JumpD, 
    input BranchD, 
    input [2:0] ALUControlD, 
    input ALUSrcD, 
    input RD1,
    input RD2, 
    input PCD, 
    input RdD, 
    input ImmExtD, 
    input PCPlus4D,

    output logic RegWriteE,
    output logic [1:0] ResultSrcE,
    output logic MemWriteE,
    output logic JumpE,
    output logic BranchE,
    output logic [2:0] ALUControlE,
    output logic ALUSrcE,
    output logic RD1E,
    output logic RD2E,
    output logic PCE, 
    output logic PdE, 
    output logic ImmExtE,
    output logic PCPlus4E

); 

always_ff @ (posedge CLK)
    begin
        RegWriteD <= RegWriteE;
        ResultSrcD <= ResultSrcE;
        MemWriteD <= MemWriteE;
        JumpD <= JumpE;
        BranchD <= BranchE;
        ALUControlD <= ALUControlE;
        ALUSrcD <= ALUSrcE;
        RD1 <= RD1E;
        RD2 <= RD2E;
        PCD <= PCE;
        RdD <= RdE;
        ImmExtD <= ImmExtE;
        PCPlus4D <= PCPlus4E;        
    end
endmodule