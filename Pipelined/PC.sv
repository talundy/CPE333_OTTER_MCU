`timescale 1ns / 1ps


module PC(
    input CLK,
    input RST,
    input logic [31:0] PCFPrime,
    output logic [31:0] PCF
    );
    
    always_ff @(posedge CLK)
    begin
        if (RST == 1'b1)
            PCF <= '0;
        else
            PCF <= PCFPrime;
    end
    
endmodule
