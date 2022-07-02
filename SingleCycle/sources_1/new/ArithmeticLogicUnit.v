`timescale 1ns / 1ps

module ArithmeticLogicUnit #(parameter AWL = 6, DWL = 32, DEPTH = 2**AWL)
                            (input [DWL-1:0] ALUIn1, ALUIn2,
                             input [AWL-2:0] Shamt,
                             input [AWL-3:0] ALUSel,
                             output reg Zero,
                             output reg [DWL-1:0] ALUOut);

    always @ (*) begin
        case (ALUSel)
            4'b0000: // Addition
                ALUOut = ALUIn1 + ALUIn2;
            4'b0001: // Subtraction
                ALUOut = ALUIn1 - ALUIn2;
            4'b0010: // SLL
                ALUOut = ALUIn2 << Shamt;
            4'b0011: // SRL
                ALUOut = ALUIn2 >> Shamt;
            4'b0100: // SLLV
                ALUOut = ALUIn2 << ALUIn1;
            4'b0101: // SRLV
                ALUOut = ALUIn2 >> ALUIn1;
            4'b0110: // SRAV
                ALUOut = ALUIn2 >>> ALUIn1;
            4'b0111: // Bitwise AND
                ALUOut = ALUIn1 & ALUIn2;
            4'b1000: // Bitwise NAND
                ALUOut = ~(ALUIn1 & ALUIn2);
            4'b1001: // Bitwise OR
                ALUOut = ALUIn1 | ALUIn2;
            4'b1010: // Bitwise NOR
                ALUOut = ~(ALUIn1 | ALUIn2);
            4'b1011: // Bitwise XOR
                ALUOut = ALUIn1 ^ ALUIn2;
            4'b1100: // Bitwise XNOR
                ALUOut = ~(ALUIn1 ^ ALUIn2);
            4'b1111: // SLT
                if (ALUIn1 < ALUIn2)
                    ALUOut = 1;
                else
                    ALUOut = 0;
            default:
                ALUOut = 32'bx;
        endcase
        if (ALUOut == 0)
            Zero = 1;
        else
            Zero = 0;
    end

endmodule
