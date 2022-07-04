`timescale 1ns / 1ps

module Mux_2x1 #(parameter AWL = 6, DWL = 32, DEPTH = 2**AWL)
            (input [DWL-1:0] In1, In2,
             input [AWL-4:0] Sel,
             output reg [DWL-1:0] Out);
    
    always @ (*) begin
        Out = Sel ? In1 : In2;
    end
    
endmodule
