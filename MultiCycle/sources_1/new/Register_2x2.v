`timescale 1ns / 1ps

module Register_2x2 #(AWL = 6, DWL = 32, DEPTH = 2**AWL)
                     (input CLK, 
                      input [DWL-1:0] D1, D2,
                      output reg [DWL-1:0] Q1, Q2);
    
    always @ (posedge CLK) begin
        Q1 <= D1;
        Q2 <= D2;
    end
    
endmodule
