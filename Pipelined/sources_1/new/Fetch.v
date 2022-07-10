`timescale 1ns / 1ps

module Fetch #(parameter AWL = 6, DWL = 32, DEPTH = 2**AWL)
              (input CLK, Stall,
               input PCSelD, JumpD,
               input [DWL-1:0] PCBranchD,
               input [DWL-1:0] PCJumpD,
               output [DWL-1:0] InstrD,
               output [DWL-1:0] PCp1D, PCF); 
               
wire [DWL-1:0] InstrF, PC_In, PC, PCp1F; 

               
Mux_2x1           #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))    
                  UUT0_0 (.In1(PCBranchD), .In2(PCp1F), 
                          .Sel(PCSelD), .Out(PC_In));
                          
Mux_2x1           #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))    
                  UUT0_1 (.In1(PCJumpD), .In2(PC_In), 
                          .Sel(JumpD), .Out(PC));
        
ProgramCounter    #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))    
                  UUT0_2 (.CLK(CLK), .EN(Stall), .PC(PC), .PCF(PCF)); 
        
InstructionMemory #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))    
                  UUT0_3 (.IMA(PCF), .IMRD(InstrF));    
        
Adder             #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))    
                  UUT0_4 (.In1(PCF), .In2(1), .Out(PCp1F));
        
Register_2x2      #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))    
                  UUT0_5 (.CLK(CLK), .EN(Stall), .CLR(PCSelD),
                          .D1(InstrF), .D2(PCp1F), 
                          .Q1(InstrD), .Q2(PCp1D));        
               
endmodule
