`timescale 1ns / 1ps

module ALUDecoder #(parameter AWL = 6, DWL = 32, DEPTH = 2**AWL)
                   (input [AWL-5:0] ALUOp,
                    input [AWL-1:0] Funct,
                    output reg [AWL-3:0] ALUSel);
                    
    always @ (*) begin
        case (ALUOp)
            2'b00:
                ALUSel = 4'b0000; // Addition
            2'b01:
                ALUSel = 4'b0001; // Subtraction
            2'b10: begin
                case (Funct)
                    6'b100000:
                        ALUSel = 4'b0000; // Addition
                    6'b100010:
                        ALUSel = 4'b0001; // Subtraction
                    6'b100100:
                        ALUSel = 4'b0111; // Bitwise AND
                    6'b100101:
                        ALUSel = 4'b1001; // Bitwise OR
                    6'b000000: 
                        ALUSel = 4'b0010; // SLL 
                    6'b000010: 
                        ALUSel = 4'b0011; // SRL
                    6'b000100: 
                        ALUSel = 4'b0100; // SLLV
                    6'b000111: 
                        ALUSel = 4'b0110; // SRAV  
                    default:
                        ALUSel = 4'bx;
                endcase
            end
            default:
                ALUSel = 4'bx;
        endcase
    end
                    
endmodule
