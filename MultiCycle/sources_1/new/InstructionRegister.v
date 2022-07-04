`timescale 1ns / 1ps

module InstructionRegister #(parameter AWL = 6, DWL = 32, DEPTH = 2**AWL)
                            (input CLK, EN,
                             input [DWL-1:0] D,
                             output reg [DWL-1:0] Q);
                             
    always @ (posedge CLK) begin
        if (EN)
            Q <= D;
    end             
                             
endmodule
