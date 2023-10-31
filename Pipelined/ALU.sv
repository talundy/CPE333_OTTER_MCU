`timescale 1ns / 1ps

module ALU(
    input [4:0] Control;  //branch,func7[5],func3
    input [31:0] A,B;
    output logic [31:0] Result; 
);
        
       
    always_comb begin //reevaluate If these change
        case(Control)
            0:  Result = A + B;     //add
            8:  Result = A - B;     //sub
            6:  Result = A | B;     //or
            7:  Result = A & B;     //and
            4:  Result = A ^ B;     //xor
            5:  Result =  A >> B[4:0];    //srl
            1:  Result =  A << B[4:0];    //sll
            13:  Result =  $signed(A) >>> B[4:0];    //sra
            2:  Result = $signed(A) < $signed(B) ? 1: 0;       //slt
            3:  Result = A < B ? 1: 0;      //sltu
            9:  Result = B; //copy op2 (lui)
            10: Result = A * B;
            default: Result = 0; 
        endcase
        //handle branching
        case({Control[4],Control[2:0]})
            8: Zero = (A == B) ? 1 : 0; //beq
            9: Zero = (A != B) ? 1 : 0; //bne
            12: Zero = ($signed(A) < $signed(B)) ? 1 : 0; //blt
            13: Zero = ($signed(A) >= $signed(B)) ? 1 : 0; //bge
            14: Zero = (A < B) ? 1 : 0; //bltu
            15: Zero = (A >= B) ? 1 : 0; //bgeu
            default: Zero = 0;
        endcase
    end
endmodule
   
  