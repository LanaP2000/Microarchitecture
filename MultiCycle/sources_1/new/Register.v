`timescale 1ns / 1ps

module Register #(parameter AWL = 6, DWL = 32, DEPTH = 2**AWL)
                 (input CLK,
                  input [DWL-1:0] D,
                  output reg [DWL-1:0] Q);
    
    always @ (posedge CLK) begin
        Q <= D;
    end
    
endmodule
