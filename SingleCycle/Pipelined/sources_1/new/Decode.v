`timescale 1ns / 1ps

module Decode #(parameter AWL = 6, DWL = 32, DEPTH = 2**AWL)
               (input CLK,
                input BranchD,
                input [DWL-1:0] InstrD, PCp1D, ALUOutM, ResultW,
                input ForwardAD, ForwardBD, 
                input Flush,
                input RFWEW,
                input [AWL-2:0] RFAW,
                output EqualD,
                output PCSelD, 
                output JumpD,
                output [DWL-1:0] PCBranchD, PCJumpD,
                output [DWL-1:0] RFRD1_q, RFRD2_q,
                output [AWL-2:0] RsE, RtE, RdE, ShamtE,
                output [DWL-1:0] SImmE,
                output [AWL-3:0] ALUSelE,
                output RFWEE, MtoRFSelE, DMWEE, ALUInSelE, RFDSelE);
                
wire [AWL-1:0] Op, Funct, ShamtD;
wire [AWL-2:0]  RsD, RtD, RdD;
wire [AWL-3:0] ALUSelD;
wire [DWL-17:0] ImmD;
wire [DWL-1:0] SImmD;
wire [DWL-1:0] RFRD1, RFRD2, ForwardADOut, ForwardBDOut;
wire RFWED, MtoRFSelD, DMWED, ALUInSelD, RFDSelD;

assign PCSelD = BranchD && EqualD && JumpD;
assign Op = InstrD[31:26];
assign Jaddr = InstrD[25:0];
assign RsD = InstrD[25:21];
assign RtD = InstrD[20:16];
assign RdD = InstrD[15:11];
assign ImmD = InstrD[15:0];
assign ShamtD = InstrD[10:6];
assign Funct = InstrD[5:0];
 
                
ControlUnit       #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))    
                  UUT1_0 (.Op(Op), .Funct(Funct), .ALUSel(ALUSelD), 
                          .MtoRFSel(MtoRFSelD), .DMWE(DMWED), .Branch(BranchD), 
                          .ALUInSel(ALUInSelD), .RFDSel(RFDSelD), .RFWE(RFWED), .Jump(JumpD)); 
        
RegisterFile      #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))    
                  UUT1_1 (.CLK(CLK), .RFWE(RFWEW), .RFWA(RFAW), .RFRA1(RsD), 
                          .RFRA2(RtD), .RFWD(ResultW), .RFRD1(RFRD1), .RFRD2(RFRD2)); 
        
SignExtensionUnit #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))    
                  UUT1_2 (.Imm(ImmD), .SImm(SImmD));    
        
Mux_2x1           #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))    
                  UUT1_3 (.In1(ALUOutM), .In2(RFRD1), .Sel(ForwardAD), .Out(ForwardADOut));
        
Mux_2x1           #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))    
                  UUT1_4 (.In1(ALUOutM), .In2(RFRD2), .Sel(ForwardBD), .Out(ForwardBDOut));  
                  
Comparator        #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))    
                  UUT1_5 (.In1(ForwardADOut), .In2(ForwardBDOut), .EqualD(EqualD));
        
Adder             #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))    
                  UUT1_6 (.In1(SImmD<<2), .In2(PCp1D), .Out(PCBranchD)); 
                  
Register_12x12    #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))    
                  UUT1_7 (.CLK(CLK), .CLR(Flush), 
                          .D1(RFWED), .D2(MtoRFSelD), .D3(DMWED), .D4(ALUSelD), .D5(ALUInSelD), .D6(RFDSelD), .D7(RFRD1),   .D8(RFRD2),   .D9(RsD), .D10(RtD), .D11(RdD), .D12(SImmD), .D13(ShamtD),
                          .Q1(RFWEE), .Q2(MtoRFSelE), .Q3(DMWEE), .Q4(ALUSelE), .Q5(ALUInSelE), .Q6(RFDSelE), .Q7(RFRD1_q), .Q8(RFRD2_q), .Q9(RsE), .Q10(RtE), .Q11(RdE), .Q12(SImmE), .Q13(ShamtE));                       
                
endmodule
