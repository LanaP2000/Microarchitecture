`timescale 1ns / 1ps

module Register #(parameter WL = 4)
                 (input CLK,
                  input [WL-1:0] D,
                  output reg [WL-1:0] Q);
 
    always @ (posedge CLK) begin
        Q <= D;
    end
    
endmodule
