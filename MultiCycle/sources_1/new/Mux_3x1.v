`timescale 1ns / 1ps

module Mux_3x1 #(parameter AWL = 6, DWL = 32, DEPTH = 2**AWL)
            (input [DWL-1:0] In1, In2, In3,
             input [AWL-3:0] Sel,
             output reg [DWL-1:0] Out);
    
    always @ (*) begin
        if (Sel == 2'b10)
            Out = In1;
        else if (Sel == 2'b01)
            Out = In2;
        else if (Sel == 2'b00)
            Out = In3;
    end
    
endmodule
