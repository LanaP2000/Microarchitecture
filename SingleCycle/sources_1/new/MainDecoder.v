`timescale 1ns / 1ps

module MainDecoder #(parameter AWL = 6, DWL = 32, DEPTH = 2**AWL)
                    (input [AWL-1:0] Opcode,
                     output reg [AWL-5:0] ALUOp,
                     output reg MtoRFSel, DMWE, 
                                Branch, ALUInSel, 
                                RFDSel, RFWE, Jump);
    
    always @ (*) begin
        case (Opcode)
        
            // R-type Instructions
            6'b000000: begin
                ALUOp = 2'b10; // Look at Function code
                MtoRFSel = 1'b0;
                DMWE = 1'b0; 
                Branch = 1'b0; 
                ALUInSel = 1'b0; 
                RFDSel = 1'b1; 
                RFWE = 1'b1;
                Jump = 1'b0;
            end
            
            // I-type Instructions
            // LW
            6'b100011: begin
                ALUOp = 2'b00; // Addition
                MtoRFSel = 1'b1;
                DMWE = 1'b0; 
                Branch = 1'b0; 
                ALUInSel = 1'b1; 
                RFDSel = 1'b0; 
                RFWE = 1'b1;
                Jump = 1'b0;
            end
            // SW
            6'b101011: begin // Addition
                ALUOp = 2'b00;
                MtoRFSel = 1'bx;
                DMWE = 1'b1; 
                Branch = 1'b0; 
                ALUInSel = 1'b1; 
                RFDSel = 1'bx; 
                RFWE = 1'b0;
                Jump = 1'b0;
            end
            // ADDI
            6'b001000: begin
                ALUOp = 2'b00; // Addition
                MtoRFSel = 1'b0;
                DMWE = 1'b0; 
                Branch = 1'b0; 
                ALUInSel = 1'b1; 
                RFDSel = 1'b0; 
                RFWE = 1'b1;
                Jump = 1'b0;
            end
            // BEQ
            6'b000100: begin
                ALUOp = 2'b01; // Subtraction
                MtoRFSel = 1'bx;
                DMWE = 1'b0; 
                Branch = 1'b1; 
                ALUInSel = 1'b0; 
                RFDSel = 1'bx; 
                RFWE = 1'b0;
                Jump = 1'b0;
            end
            
            // J-type Instructions
            // Jump
            6'b000010: begin
                ALUOp = 2'bx;
                MtoRFSel = 1'bx;
                DMWE = 1'b0; 
                Branch = 1'bx; 
                ALUInSel = 1'bx; 
                RFDSel = 1'bx; 
                RFWE = 1'b0;
                Jump = 1'b1;
            end
            
            default: begin
                ALUOp = 2'bx;
                MtoRFSel = 1'bx;
                DMWE = 1'b0; 
                Branch = 1'b0; 
                ALUInSel = 1'bx; 
                RFDSel = 1'bx; 
                RFWE = 1'b0;
                Jump = 1'b0;
            end
        endcase
    end
    
endmodule
