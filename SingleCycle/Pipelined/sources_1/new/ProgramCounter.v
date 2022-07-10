`timescale 1ns / 1ps

module ProgramCounter #(parameter AWL = 6, DWL = 32, DEPTH = 2**AWL)
                       (input CLK, EN,
                        input [DWL-1:0] PC,
                        output reg [DWL-1:0] PCF);

initial PCF = 0;
   
    always @ (negedge CLK) begin
        if (!EN) // Active-low enable signal
            PCF <= PC;
    end
    
endmodule
