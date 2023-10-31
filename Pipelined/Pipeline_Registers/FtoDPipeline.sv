`timescale 1ps/1ps

module FtoD(
    input CLK,
    input [31:0] InstrF,
    input [31:0] PCF,
    input [31:0] PCPlus4F,
    output logic [31:0] InstrD,
    output logic [31:0] PCD,
    output logic [31:0] PCPlus4D
);

always_ff @ (posedge CLK) 
    begin
        InstrD <= InstrF;
        PCD <= PCF;
        PCPlus4D <= PCPlus4F;
    end    
endmodule