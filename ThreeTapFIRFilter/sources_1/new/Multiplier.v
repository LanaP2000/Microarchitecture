`timescale 1ns / 1ps

`define WL_Mult (WL1 > WL2) ? (2 * WL1) : (2 * WL2)

module Multiplier #(parameter WL1 = 4, WL2 = 4)
                   (input signed [WL1-1:0] In1, 
                    input signed [WL2-1:0] In2,   
                    output reg signed [`WL_Mult-1:0] Out);
    
    always @ (*) begin
        Out = In1 * In2;
    end
    
endmodule
