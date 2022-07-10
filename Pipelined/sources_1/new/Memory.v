`timescale 1ns / 1ps

module Memory #(parameter AWL = 6, DWL = 32, DEPTH = 2**AWL)
               (input CLK,
                input RFWEM, MtoRFSelM, DMWEM,
                input [DWL-1:0] ALUOutM, DMdinM, 
                input [AWL-2:0] RFAM,
                output RFWEW, MtoRFSelW, 
                output [DWL-1:0] DMOutW, ALUOutW, 
                output [AWL-2:0] RFAW);
                
wire [DWL-1:0] DMOutM;
              
                
DataMemory   #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))    
             UUT3_0 (.CLK(CLK), .DMWE(DMWEM), .DMWA(ALUOutM), .DMWD(DMdinM), .DMRD(DMOutM));  
                  
Register_5x5 #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))    
             UUT3_1 (.CLK(CLK), 
                     .D1(RFWEM), .D2(MtoRFSelM), .D3(DMOutM), .D4(ALUOutM), .D5(RFAM), 
                     .Q1(RFWEW), .Q2(MtoRFSelW), .Q3(DMOutW), .Q4(ALUOutW), .Q5(RFAW));         
                
endmodule
