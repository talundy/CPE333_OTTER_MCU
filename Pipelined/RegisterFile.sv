`timescale 1ns / 1ps


module RegisterFile(
    input CLK,
    input [4:0] A1,     //register address to read
    input [4:0] A2,
    input WE3,          //write enable
    input [31:0] WD3,   //data to write to address 3
    input [4:0] A3,     //register address to write to

    output logic [31:0] RD1,
    output logic [31:0] RD2
);


    logic [31:0] RF [31:0]; //32 registers each 32 bits long
    
    //assign Data1 = RF[Read1];
    //assign Data2 = RF[Read2];
    always_comb begin
        if(A1==0) 
            RD1 = 0;
        else
            RD1 = RF[A1];
    end

    always_comb begin
        if(A2==0) 
            RD2 = 0;
        else 
            RD2 = RF[A2];
    end

    //CLK is negated in the input, making this technically negedge
    always_ff @(posedge CLK) begin // write the register with the new value if Regwrite is high
        if(WE3 && A3 != 0) 
            RF[A3] <= WD3;
    end
    
 endmodule

