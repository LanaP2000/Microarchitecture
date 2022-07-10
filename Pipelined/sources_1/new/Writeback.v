`timescale 1ns / 1ps

module Writeback #(parameter AWL = 6, DWL = 32, DEPTH = 2**AWL)
                  (input CLK,
                   input RFWEW,
                   input MtoRFSelW,
                   input [DWL-1:0] DMOutW, ALUOutW,
                   output [AWL-2:0] RFAW,
                   output [DWL-1:0] ResultW);
                   
Mux_2x1 #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))    
        UUT4_0 (.In1(DMOutW), .In2(ALUOutW), .Sel(MtoRFSelW), .Out(ResultW));       
                   
endmodule
