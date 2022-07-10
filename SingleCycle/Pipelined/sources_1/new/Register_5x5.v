`timescale 1ns / 1ps

module Register_5x5 #(parameter AWL = 6, DWL = 32, DEPTH = 2**AWL)
                     (input CLK,
                      input D1, D2, 
                      input [DWL-1:0] D3, D4, 
                      input [AWL-2:0] D5,
                      output reg Q1, Q2, 
                      output reg [DWL-1:0] Q3, Q4, 
                      output reg [AWL-2:0] Q5);
    
    always @ (posedge CLK) begin
        Q1 <= D1;
        Q2 <= D2;
        Q3 <= D3;
        Q4 <= D4;
        Q5 <= D5;
    end
    
endmodule
