`timescale 1ns / 1ps

module Adder #(parameter AWL = 6, DWL = 32, DEPTH = 2**AWL)
              (input [DWL-1:0] In1, In2,
               output reg [DWL-1:0] Out);
    
    always @ (*) begin
        Out = In1 + In2;
    end    
    
endmodule
