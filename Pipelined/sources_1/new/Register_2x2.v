`timescale 1ns / 1ps

module Register_2x2 #(parameter AWL = 6, DWL = 32, DEPTH = 2**AWL)
                     (input CLK, EN, CLR,
                      input [DWL-1:0] D1, D2,
                      output reg [DWL-1:0] Q1, Q2);
    
    always @ (posedge CLK) begin
        if (!EN) begin // Active-low enable signal
            Q1 <= D1;
            Q2 <= D2;
        end
        if (CLR) begin
            Q1 <= 0;
            Q2 <= 0;
        end
    end
    
endmodule
