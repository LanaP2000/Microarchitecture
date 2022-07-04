`timescale 1ns / 1ps

module ControlUnit #(parameter AWL = 6, DWL = 32, DEPTH = 2**AWL)
                    (input CLK, RST,
                     input [AWL-1:0] Opcode, Funct,
                     output [AWL-3:0] ALUSel,
                     output IRWE, MWE, PCWE, Branch, RFWE,
                     output [AWL-5:0] ALUIn2Sel, PCSel,
                     output MtoRFSel, RFDSel,
                            ALUIn1Sel, IDSel);
                     
wire [AWL-5:0] ALUOp;

// FSM
MainController #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))  
               UUT0_0 (.CLK(CLK), .RST(RST), .Opcode(Opcode), .MtoRFSel(MtoRFSel), 
                       .RFDSel(RFDSel), .IDSel(IDSel), .PCSel(PCSel), .ALUOp(ALUOp), 
                       .ALUIn1Sel(ALUIn1Sel), .ALUIn2Sel(ALUIn2Sel), 
                       .IRWE(IRWE), .MWE(MWE), .PCWE(PCWE), .Branch(Branch), .RFWE(RFWE));
               
ALUDecoder     #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))
               UUT0_1 (.ALUOp(ALUOp), .Funct(Funct), .ALUSel(ALUSel));
                     
endmodule
