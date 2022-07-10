`timescale 1ns / 1ps

module Pipelined #(parameter AWL = 6, DWL = 32, DEPTH = 2**AWL)
                  (input CLK,
                   output [DWL-1:0] ResultW);
   
wire Stall, Flush;
wire RFWEE, RFWEM, RFWEW;
wire MtoRFSelE, MtoRFSelM, MtoRFSelW;
wire DMWEE, DMWEM;
wire ALUInSelE;
wire RFDSelE;
wire PCSelD, BranchD, EqualD, JumpD;
wire [AWL-3:0] ALUSelE;
wire [DWL-1:0] InstrD, PCp1D, PCBranchD, PCJumpD;
wire [DWL-1:0] PCF, SImmE, RFRD1_q, RFRD2_q;
wire [AWL-2:0] RsD, RtD, RdD, ShamtD;
wire [AWL-2:0] RsE, RtE, RdE, ShamtE;
wire [DWL-1:0] ALUOutM, DMdinM;
wire [DWL-1:0] DMOutW, ALUOutW;
wire [AWL-2:0] RFAE, RFAM, RFAW;
wire ForwardAD, ForwardBD;
wire [AWL-5:0] ForwardAE, ForwardBE;
wire [DWL-7:0] Jaddr;

assign PCSelD = BranchD && EqualD && JumpD;
assign Op = InstrD[31:26];
assign Jaddr = InstrD[25:0];
assign RsD = InstrD[25:21];
assign RtD = InstrD[20:16];
assign RdD = InstrD[15:11];
assign ImmD = InstrD[15:0];
assign ShamtD = InstrD[10:6];
assign Funct = InstrD[5:0];
assign PCJumpD = {PCF[31:26], Jaddr};
   
                   
Fetch      #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))
           UUT0 (.CLK(CLK), .Stall(Stall), .PCSelD(PCSelD), .JumpD(JumpD), .PCJumpD(PCJumpD), .PCBranchD(PCBranchD), 
                 .InstrD(InstrD), .PCp1D(PCp1D), .PCF(PCF));
      
Decode     #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))
           UUT1 (.CLK(CLK), .BranchD(BranchD), .EqualD(EqualD), .InstrD(InstrD), .PCp1D(PCp1D), .ALUOutM(ALUOutM), 
                 .ResultW(ResultW), .ForwardAD(ForwardAD), .ForwardBD(ForwardBD), 
                 .Flush(Flush), .RFWEW(RFWEW), .RFAW(RFAW), .PCSelD(PCSelD), 
                 .PCBranchD(PCBranchD), .RFRD1_q(RFRD1_q), .RFRD2_q(RFRD2_q), 
                 .RsE(RsE), .RtE(RtE), .RdE(RdE), .SImmE(SImmE), .ALUInSelE(ALUInSelE), 
                 .RFWEE(RFWEE), .MtoRFSelE(MtoRFSelE), .DMWEE(DMWEE), 
                 .ALUSelE(ALUSelE), .RFDSelE(RFDSelE), .ShamtE(ShamtE), .JumpD(JumpD), .PCJumpD(PCJumpD));
       
Execute    #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))
           UUT2 (.CLK(CLK), .RFAE(RFAE), .RFRD1_q(RFRD1_q), .RFRD2_q(RFRD2_q), 
                 .RFWEE(RFWEE), .MtoRFSelE(MtoRFSelE), .DMWEE(DMWEE), 
                 .ALUSelE(ALUSelE), .RFDSelE(RFDSelE), .ALUInSelE(ALUInSelE), 
                 .RsE(RsE), .RtE(RtE), .RdE(RdE), .ShamtE(ShamtE), .SImmE(SImmE), .ResultW(ResultW), 
                 .ForwardAE(ForwardAE), .ForwardBE(ForwardBE), .RFWEM(RFWEM), 
                 .MtoRFSelM(MtoRFSelM), .DMWEM(DMWEM), .ALUOutM(ALUOutM), 
                 .DMdinM(DMdinM), .RFAM(RFAM));
        
Memory     #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))
           UUT3 (.CLK(CLK), .RFWEM(RFWEM), .MtoRFSelM(MtoRFSelM), .DMWEM(DMWEM), 
                 .ALUOutM(ALUOutM), .DMdinM(DMdinM), .RFAM(RFAM), .RFWEW(RFWEW), 
                 .MtoRFSelW(MtoRFSelW), .DMOutW(DMOutW), .ALUOutW(ALUOutW), .RFAW(RFAW));
       
Writeback  #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))
           UUT4 (.CLK(CLK), .RFWEW(RFWEW), .MtoRFSelW(MtoRFSelW), .DMOutW(DMOutW), .ALUOutW(ALUOutW), .RFAW(RFAW), 
                 .ResultW(ResultW));
          
HazardUnit #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))
           UUT5 (.BranchD(BranchD), .RsD(RsD), .RtD(RtD), .RsE(RsE), .RtE(RtE), 
                 .RFAE(RFAE), .RFAM(RFAM), .RFAW(RFAW), .Stall(Stall), .Flush(Flush), 
                 .MtoRFSelE(MtoRFSelE), .MtoRFSelM(MtoRFSelM), .RFWEE(RFWEE), 
                 .RFWEM(RFWEM), .RFWEW(RFWEW), .ForwardAD(ForwardAD), 
                 .ForwardBD(ForwardBD), .ForwardAE(ForwardAE), .ForwardBE(ForwardBE));

endmodule
