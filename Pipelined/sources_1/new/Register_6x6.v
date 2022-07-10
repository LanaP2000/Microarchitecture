`timescale 1ns / 1ps

module Register_6x6 #(parameter AWL = 6, DWL = 32, DEPTH = 2**AWL)
                     (input CLK,
                      input D1, D2, D3, 
                      input [DWL-1:0] D4, D5, 
                      input [AWL-2:0] D6,
                      output reg Q1, Q2, Q3, 
                      output reg [DWL-1:0] Q4, Q5, 
                      output reg [AWL-2:0] Q6);
    
    always @ (posedge CLK) begin
        Q1 <= D1;
        Q2 <= D2;
        Q3 <= D3;
        Q4 <= D4;
        Q5 <= D5;
        Q6 <= D6;
    end
    
endmodule
