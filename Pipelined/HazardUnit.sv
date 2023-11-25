`timescale 1ns / 1ps
// Engineer: Thomas Choboter
// 24 November 2023
// For CPE 333 Laboratory assignment 4
module HazardUnit(
    input [4:0] Rs1D,
    input [4:0] Rs2D,
    input [4:0] RdE,
    input [4:0] Rs1E,
    input [4:0] Rs2E,
    input PCSrcE, 
    input ResultSrcE0,
    input [4:0] RdM,
    input RegWriteM,
    input [4:0] RdW,
    input RegWriteW,
    output logic StallF,
    output logic StallD,
    output logic FlushD,
    output logic FlushE,
    output logic [1:0] ForwardAE,
    output logic [1:0] ForwardBE
);


    // Data Hazards requiring a stall for loading if the next source register uses the load
    wire lwStall;
    assign lwStall = ((Rs1D == RdE) || (Rs2D == RdE)) && ResultSrcE0;
    assign StallF = lwStall;
    assign StallD = lwStall;

    // Control hazards that flush data if a branch is taken (PCSrcE)
    assign FlushE = lwStall || PCSrcE;
    assign FlushD = PCSrcE

    // Data forwarding logic, for when the destination register is the
    // same register as a source register somewhere earlier in the pipeline
    always_comb begin
        if (RegWriteM && Rs1E != 5'd0 && Rs1E == RdM)
            ForwardAE = 2'b10;
        else if (RegWriteW && Rs1E != 5'd0 && Rs1E == RdW)
            ForwardAE = 2'b01;
        else
            ForwardAE = 2'b00;

        if (RegWriteM && Rs2E != 5'd0 && Rs2E == RdM)
            ForwardBE = 2'b10;
        else if (RegWriteW && Rs2E != 5'd0 && Rs2E == RdW)
            ForwardBE = 2'b01;
        else
            ForwardBE = 2'b00;
    end

endmodule