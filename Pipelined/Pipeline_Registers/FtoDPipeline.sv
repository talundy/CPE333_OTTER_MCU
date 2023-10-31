`timescale 1ps/1ps

module FtoD(
    input CLK,
    input InstrF,
    input PCF,
    input PCPlus4F,
    output logic InstrD,
    output logic PCD,
    output logic PCPlus4D
);

always_ff @ (posedge CLK) 
    begin
        InstrD <= InstrF;
        PCD <= PCF;
        PCPlus4D <= PCPlus4F;
    end    
endmodule