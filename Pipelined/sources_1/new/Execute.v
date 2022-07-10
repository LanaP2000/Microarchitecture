`timescale 1ns / 1ps

module Execute #(parameter AWL = 6, DWL = 32, DEPTH = 2**AWL)
                (input CLK,
                 input [AWL-2:0] RFAE,
                 input [31:0] RFRD1_q, RFRD2_q,
                 input RFWEE, MtoRFSelE, DMWEE, ALUInSelE, RFDSelE,
                 input [AWL-3:0] ALUSelE,
                 input [AWL-2:0] RsE, RtE, RdE, ShamtE,
                 input [DWL-1:0] SImmE,
                 input [DWL-1:0] ResultW,
                 input [AWL-5:0] ForwardAE, ForwardBE,
                 output RFWEM, MtoRFSelM, DMWEM,
                 output [DWL-1:0] ALUOutM, DMdinM, 
                 output [AWL-2:0] RFAM);

wire [DWL-1:0] ALUIn1E, ALUIn2E, DMdinE, ALUOutE;
           
                 
Mux_2x1             #(.AWL(AWL), .DWL(DWL-27), .DEPTH(DEPTH))    
                    UUT2_0 (.In1(RdE), .In2(RtE), .Sel(RFDSelE), .Out(RFAE));
        
Mux_3x1             #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))    
                    UUT2_1 (.In1(ALUOutM), .In2(ResultW), .In3(RFRD1_q), .Sel(ForwardAE), .Out(ALUIn1E)); 
        
Mux_3x1             #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))    
                    UUT2_2 (.In1(ALUOutM), .In2(ResultW), .In3(RFRD2_q), .Sel(ForwardBE), .Out(DMdinE));    
        
Mux_2x1             #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))    
                    UUT2_3 (.In1(SImmE), .In2(DMdinE), .Sel(ALUInSelE), .Out(ALUIn2E));
        
ArithmeticLogicUnit #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))    
                    UUT2_4 (.ALUIn1(ALUIn1E), .ALUIn2(ALUIn2E), .Shamt(ShamtE), .ALUSel(ALUSelE), .ALUOut(ALUOutE));  
                  
Register_6x6        #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))    
                    UUT2_7 (.CLK(CLK), .D1(RFWEE), .D2(MtoRFSelE), .D3(DMWEE), .D4(ALUOutE), .D5(DMdinE), .D6(RFAE), 
                                       .Q1(RFWEM), .Q2(MtoRFSelM), .Q3(DMWEM), .Q4(ALUOutM), .Q5(DMdinM), .Q6(RFAM));          
                 
endmodule
