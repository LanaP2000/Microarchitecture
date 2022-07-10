`timescale 1ns / 1ps

module Comparator #(parameter AWL = 6, DWL = 32, DEPTH = 2**AWL)
                   (input [DWL-1:0] In1, In2,
                    output reg EqualD);
                    
    always @ (*) begin
        if (In1 == In2)
            EqualD = 1'b1;
        else
            EqualD = 1'b0;
    end
                    
endmodule
