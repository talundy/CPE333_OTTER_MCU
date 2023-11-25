`timescale 1ns / 1ps


module PC(
    input CLK,
    input RST,
    input EN,
    input logic [31:0] PCFPrime,
    output logic [31:0] PCF
    );
    
    always_ff @(posedge CLK) begin
        if (EN) begin
            if (RST == 1'b1)
                PCF <= '0;
            else
                PCF <= PCFPrime;
        end
    end
    
endmodule
