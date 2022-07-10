`timescale 1ns / 1ps

module ControlUnit #(parameter AWL = 6, DWL = 32, DEPTH = 2**AWL)
                    (input [AWL-1:0] Op, 
                     input [AWL-1:0] Funct,
                     output [AWL-3:0] ALUSel,
                     output MtoRFSel, DMWE, 
                            Branch, ALUInSel, 
                            RFDSel, RFWE, Jump);
     
wire [AWL-5:0] ALUOp;
                     
MainDecoder #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH)) 
            UUT5_0 (.Opcode(Op), .ALUOp(ALUOp), .MtoRFSel(MtoRFSel), 
                    .DMWE(DMWE), .Branch(Branch), .ALUInSel(ALUInSel), 
                    .RFDSel(RFDSel), .RFWE(RFWE), .Jump(Jump));
            
ALUDecoder  #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH)) 
            UUT5_1 (.ALUOp(ALUOp), .Funct(Funct), .ALUSel(ALUSel));             
                     
endmodule
