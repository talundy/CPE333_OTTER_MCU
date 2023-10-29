`timescale 1ns / 1ps

module Otter(
    input [31:0] IOBUS_IN,
    input RST,
    input INTR,
    input CLK,
    output [31:0] IOBUS_OUT,
    output [31:0] IOBUS_ADDR,
    output IOBUS_WR
    );

    //F STAGE wires (Fetch Instruction)
    wire [31:0] PCFPrime, PCF, PCPlus4F, InstrF;

    //D STAGE wires (Decode Instruction)
    wire [31:0] InstrD, PCD, PCPlus4D
    //---------------------//
    wire RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD;
    wire [1:0] ResultSrcD, ImmSrcD;
    wire [2:0] ALUControlD;
    wire [31:0] RD1, RD2;
    wire [31:0] ImmExtD;

    //E STAGE wires (Execute Instruction)
    wire RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE;
    wire [1:0] ResultSrcE;
    wire [2:0] ALUControlE;
    wire [31:0] RD1E, RD2E, PCE, ImmExtE, PCPlus4E;
    wire [4:0] RdE;
    //---------------------//
    wire [31:0] ALUResultE;
    wire ZeroE, PCSrcE;
    wire [31:0] SrcBE, PCTargetE;

    //M STAGE wires (Access Data Memory)
    wire RegWriteM, MemWriteM,
    wire [1:0] ResultSrcM;
    wire [31:0] ALUResultM, WriteDataM, PCPlus4M;
    wire [4:0] RdM;
    //---------------------//
    wire [31:0] ReadDataM;

    //W STAGE wires (Write to Reg File)
    wire RegWriteW;
    wire [1:0] ResultSrcW;
    wire [31:0] ALUResultW, ReadDataW, PCPlus4W;
    wire [4:0] RdW;
    //---------------------//
    wire [31:0] ResultW;

    //F STAGE modules
    Mux2 OtterPCMux(
        .Src(PCSrcE),
        .Arg0(PCPlus4F),
        .Arg1(PCTargetE),

        .Result(PCFPrime)
    );

    PC OtterPC(
        .CLK(CLK),
        .RST(RST),
        .PCFPrime(PCFPrime),

        .PCF(PCF)
    );

    Adder OtterAddFour(
        .SrcA(PCF),
        .SrcB(32'h00000004),

        .Result(PCPlus4F)
    );

    //
    // DO INSTRUCTION MEMORY and DATA MEMORY at the SAME TIME
    //

    FtoD OtterFtoD(
        .CLK(CLK),
        .InstrF(InstrF),
        .PCF(PCF),
        .PCPlus4F(PCPlus4F),
        
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D)
    );

    //D STAGE modules
    ControlUnit OtterControlUnit(
        .op(InstrD[6:0]),
        .funct3(InstrD[14:12]),
        .funct7(InstrD[30]),

        .RegWriteD(RegWriteD),
        .ResultSrcD(ResultSrcD),
        .MemWriteD(MemWriteD),
        .JumpD(JumpD),
        .BranchD(BranchD),
        .ALUControlD(ALUControlD),
        .ALUSrcD(ALUSrcD),
        .ImmSrcD(ImmSrcD)
    );

    RegisterFile OtterRegisterFile(
        .CLK(~CLK), //INVERTED clock passed in here for register writing!!
        .A1(InstrD[19:15]),
        .A2(InstrD[24:20]),
        .WE3(RegWriteW), //Data write enable
        .WD3(ResultW), //Data to Write
        .A3(RdW), //Address to Write

        .RD1(RD1),
        .RD2(RD2)
    );

    Extend OtterExtend(
        .Imm(InstrD[31:7]),
        .ImmSrcD(ImmSrcD),

        .ImmExtD(ImmExtD)
    );

    DtoE OtterDtoE(
        .CLK(CLK),
        .RegWriteD(RegWriteD),
        .ResultSrcD(ResultSrcD),
        .MemWriteD(MemWriteD),
        .JumpD(JumpD),
        .BranchD(BranchD),
        .ALUControlD(ALUControlD),
        .ALUSrcD(ALUSrcD),
        .RD1(RD1),
        .RD2(RD2),
        .PCD(PCD),
        .RdD(Instr[11:7]),
        .ImmExtD(ImmExtD),
        .PCPlus4D(PCPlus4D),

        .RegWriteE(RegWriteE),
        .ResultSrcE(ResultSrcE),
        .MemWriteE(MemWriteE),
        .JumpE(JumpE),
        .BranchE(BranchE),
        .ALUControlE(ALUControlE),
        .ALUSrcE(ALUSrcE),
        .RD1E(RD1E),
        .RD2E(RD2E),
        .PCE(PCE),
        .RdE(RdE),
        .ImmExtE(ImmExtE),
        .PCPlus4E(PCPlus4E)
    );

    //E STAGE modules
    assign PCSrcE = (ZeroE & BranchE) | JumpE;

    ALU OtterALU(
        .SrcAE(RD1E),
        .SrcBE(SrcBE),
        .ALUControlE(ALUControlE),
        
        .ALUResultE(ALUResultE),
        .ZeroE(ZeroE)
    );

    Mux2 OtterALUMux(
        .Src(ALUSrcE),
        .Arg0(RD2E),
        .Arg1(ImmExtE),

        .Result(SrcBE)
    );

    Adder OtterPCImmAdd(
        .SrcA(PCE),
        .SrcB(ImmExtE),

        .Result(PCTargetE)
    );

    EtoM OtterEtoM(
        .CLK(CLK),
        .RegWriteE(RegWriteE),
        .ResultSrcE(ResultSrcE),
        .MemWriteE(MemWriteE),
        .ALUResultE(ALUResultE),
        .RD2E(RD2E), //WriteDataE
        .RdE(RdE),
        .PCPlus4E(PCPlus4E),

        .RegWriteM(RegWriteM),
        .ResultSrcM(ResultSrcM),
        .MemWriteM(MemWriteM),
        .ALUResultM(ALUResultM),
        .WriteDataM(WriteDataM),
        .RdM(RdM),
        .PCPlus4M(PCPlus4M)
    );

    //M STAGE modules
    Memory OtterMemory(
        //Instructions
        .PCF(PCF), //Address
        
        .InstrF(InstrF), //Data at Address
        //Data
        .CLK(CLK),
        .A(ALUResultM), //Address
        .WD(WriteDataM), //Data to Write
        .WE(MemWriteM), //Write enable
        
        .RD(ReadDataM) //Data at Address
    );

    MtoW OtterMtoW(
        .CLK(CLK),
        .RegWriteM(RegWriteM),
        .ResultSrcM(ResultSrcM),
        .ALUResultM(ALUResultM),
        .ReadDataM(ReadDataM),
        .RdM(RdM),
        .PCPlus4M(PCPlus4M),

        .RegWriteW(RegWriteW),
        .ResultSrcW(ResultSrcW),
        .ALUResultW(ALUResultW),
        .ReadDataW(ReadDataW),
        .RdW(RdW),
        .PCPlus4W(PCPlus4W)
    );

    //W STAGE modules
    Mux4 OtterRegMux(
        .Src(ResultSrcW),
        .Arg0(ALUResultW),
        .Arg1(ReadDataW),
        .Arg2(PCPlus4W),
        //No Arg3 (for now)

        .Result(ResultW)
    );

endmodule