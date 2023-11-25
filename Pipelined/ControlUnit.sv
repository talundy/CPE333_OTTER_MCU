`timescale 1ns / 1ps


module ControlUnit(
    input [31:0] Instr,
    output logic RegWrite,
    output logic [1:0] ResultSrc,
    output logic MemWrite,
    output logic [1:0] MemSize,
    output logic MemSign,
    output logic Jump,
    output logic Branch,
    output logic [4:0] ALUControl,
    output logic ALUSrc,
    output logic [2:0] ImmSrc
);

    wire [6:0] Opcode = Instr[6:0];
    assign MemSign = Instr[14];
    assign MemSize = Instr[13:12];
    // Branch is 1 if a branch instruction is being executed
    assign Branch = (Opcode == 7'b1100011) ? 1 : 0;
    // Jump is 1 if JAL or JALR
    assign Jump = (Opcode == 7'b1101111 || Opcode == 7'b1100111) ? 1 : 0;
    // MemWrite is 1 if store
    assign MemWrite = (Opcode == 7'b0100011) ? 1 : 0;
    
    
    // RegWrite is true as long as the instruction isn't Branch (1100011) or Store (0100011)
    assign RegWrite = (Opcode[5:0] == 6'b100011) ? 0 : 1;
    // ALUSrc is 1 for immediates, LUI, Immeds - JALR, Store
    assign ALUSrc = (Opcode == 7'b0110111 || Opcode == 7'b0000011 || 
                    Opcode == 7'b0010011 || Opcode == 7'b0100011) ? 1 : 0;
    
    always_comb begin
        case(Opcode)
            7'b1100111,
            7'b0000011,
            7'b0010011: ImmSrc = 3'd1; // I-type
            7'b0100011: ImmSrc = 3'd2; // S-type
            7'b1100011: ImmSrc = 3'd3; // B-type
            7'b0110111,
            7'b0010111: ImmSrc = 3'd4; // U-type
            7'b1101111: ImmSrc = 3'd5; // J-type
            default: ImmSrc = 3'd0;
        endcase
        case(Opcode)
            7'b0000011: ResultSrc = 2'd1; // Load instructions
            7'b0010111, //AUIPC
            7'b1101111, //JAL, v JALR v
            7'b1100111: ResultSrc = 2'd2; // RegFile gets PC + 4
            default: ResultSrc = 2'd0;
        endcase
        case(Opcode)
            7'b0110111: ALUControl = 5'b01001; //lui
            7'b0000011,
            7'b0100011: ALUControl = 5'b00000; //load or store, add
            default: ALUControl = {Branch, Instr[30], Instr[14:12]};
        endcase
    end




endmodule
