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
    wire RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD, MemSignD;
    wire [1:0] ResultSrcD, MemSizeD;
    wire [2:0] ImmSrcD;
    wire [4:0] ALUControlD;
    wire [31:0] RD1, RD2;
    wire [31:0] ImmExtD;

    //E STAGE wires (Execute Instruction)
    wire RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE, MemSignE;
    wire [1:0] ResultSrcE, MemSizeE;
    wire [4:0] ALUControlE;
    wire [31:0] RD1E, RD2E, PCE, ImmExtE, PCPlus4E;
    wire [4:0] RdE;
    //---------------------//
    wire [31:0] ALUResultE;
    wire ZeroE, PCSrcE;
    wire [31:0] SrcBE, PCTargetE;

    //M STAGE wires (Access Data Memory)
    wire RegWriteM, MemWriteM, MemSignM,
    wire [1:0] ResultSrcM, MemSizeM;
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
        .Instr(InstrD),

        .RegWrite(RegWriteD),
        .ResultSrc(ResultSrcD),
        .MemWrite(MemWriteD),
        .Jump(JumpD),
        .Branch(BranchD),
        .ALUControl(ALUControlD),
        .ALUSrc(ALUSrcD),
        .ImmSrc(ImmSrcD),
        .MemSize(MemSizeD),
        .MemSign(MemSignD)
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
        .ImmSrc(ImmSrcD),

        .ImmExt(ImmExtD)
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
        .MemSizeD(MemSizeD),
        .MemSignD(MemSignD),

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
        .PCPlus4E(PCPlus4E),
        .MemSizeE(MemSizeE),
        .MemSignE(MemSignE)
    );

    //E STAGE modules
    assign PCSrcE = (ZeroE & BranchE) | JumpE;

    ALU OtterALU(
        .A(RD1E),
        .B(SrcBE),
        .Control(ALUControlE),
        
        .Result(ALUResultE),
        .Zero(ZeroE)
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
        .MemSizeE(MemSizeE),
        .MemSignE(MemSignE),

        .RegWriteM(RegWriteM),
        .ResultSrcM(ResultSrcM),
        .MemWriteM(MemWriteM),
        .ALUResultM(ALUResultM),
        .WriteDataM(WriteDataM),
        .RdM(RdM),
        .PCPlus4M(PCPlus4M)
        .MemSizeM(MemSizeM),
        .MemSignM(MemSignM)
    );

    //M STAGE modules
    Memory OtterMemory(
        //Instructions
        .MEM_ADDR1(PCF), //Address
        
        .MEM_DOUT1(InstrF), //Data at Address
        //Data
        .MEM_CLK(CLK),
        .MEM_ADDR2(ALUResultM), //Address
        .MEM_DIN2(WriteDataM), //Data to Write
        .MEM_WRITE2(MemWriteM), //Write enable
        
        .MEM_DOUT2(ReadDataM) //Data at Address
        .MEM_SIZE(MemSizeM),
        .MEM_SIGN(MemSignM),
        //not using right now
        .MEM_READ1(1),
        .MEM_READ2(1),
        .IO_IN(32'd0)
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