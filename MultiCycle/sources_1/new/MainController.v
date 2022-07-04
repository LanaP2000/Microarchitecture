`timescale 1ns / 1ps

module MainController #(parameter AWL = 6, DWL = 32, DEPTH = 2**AWL)
                    (input CLK, RST,
                     input [AWL-1:0] Opcode,
                     output reg [AWL-5:0] ALUOp,
                     output reg IRWE, MWE, PCWE, Branch, RFWE,
                     output reg [AWL-5:0] ALUIn2Sel, PCSel,
                     output reg MtoRFSel, RFDSel,
                                ALUIn1Sel, IDSel);

// States    
localparam SR = 0,   // Reset
           S0 = 1,   // Fetch
           S1 = 2,   // Decode
           S2 = 3,   // MemAddr
           S3 = 4,   // MemRead
           S4 = 5,   // Mem Writeback
           S5 = 6,   // DMWE
           S6 = 7,   // Execute
           S7 = 8,   // ALU Writeback
           S8 = 9,   // Branch
           S9 = 10,  // Jump
           S10 = 11, // ADDI Execute
           S11 = 12; // ADDI Writeback
           
reg [3:0] state, next_state;
           
    // STATE REGISTER       
    always @ (posedge CLK) begin
        if (RST)
            state <= SR;
        else
            state <= next_state;
    end
    
    // NEXT STATE LOGIC
    always @ (state or Opcode) begin
        case (state)
            SR: begin 
                next_state = S0;
            end
            S0: begin
                next_state = S1;
            end
            S1: begin
                if (Opcode == 6'b100011 || Opcode == 6'b101011) // LW or SW
                    next_state = S2;
                else if (Opcode == 6'b000000) // R-type
                    next_state = S6;
                else if (Opcode == 6'b000100) // BEQ
                    next_state = S8;
                else if (Opcode == 6'b000010) // J
                    next_state = S9;
                else if (Opcode == 6'b001000) // ADDI
                    next_state = S10;
                else
                    next_state = SR;
            end
            S2: begin
                if (Opcode == 6'b100011) // LW
                    next_state = S3;
                else if (Opcode == 6'b101011) // SW
                    next_state = S5;
            end
            S3: begin
                next_state = S4;
            end
            S4: begin
                next_state = S0;
            end
            S5: begin
                next_state = S0;
            end
            S6: begin
                next_state = S7;
            end
            S7: begin
                next_state = S0;
            end
            S8: begin
                next_state = S0;
            end
            S9: begin
                next_state = S0;
            end
            S10: begin
                next_state = S11;
            end
            S11: begin
                next_state = S0;
            end
        endcase
    end
    
    // OUTPUT LOGIC
    always @ (state) begin
        case (state)
            SR: begin // Reset
                IRWE = 0;
                MWE = 0;
                PCWE = 0; 
                Branch = 0; 
                RFWE = 0;
                ALUOp = 2'bx; 
                ALUIn1Sel = 1'bx;
                ALUIn2Sel = 2'bx;
                PCSel = 2'bx;
                MtoRFSel = 1'bx; 
                RFDSel = 1'bx;
                IDSel = 1'bx;
            end
            S0: begin // Fetch
                IRWE = 1;
                MWE = 0;
                PCWE = 1; 
                Branch = 0; 
                RFWE = 0;
                ALUOp = 2'b00; 
                ALUIn1Sel = 1'b0;
                ALUIn2Sel = 2'b01;
                PCSel = 2'b00;
                MtoRFSel = 1'b0; 
                RFDSel = 1'bx;
                IDSel = 1'b0;
            end
            S1: begin // Decode
                IRWE = 0;
                MWE = 0;
                PCWE = 0; 
                Branch = 0; 
                RFWE = 0;
                ALUOp = 2'bx; 
                ALUIn1Sel = 1'bx;
                ALUIn2Sel = 2'bx;
                PCSel = 2'bx;
                MtoRFSel = 1'b0; 
                RFDSel = 1'bx;
                IDSel = 1'bx;
            end
            S2: begin // MemAddr
                IRWE = 0;
                MWE = 0;
                PCWE = 0; 
                Branch = 0; 
                RFWE = 0;
                ALUOp = 2'b00; 
                ALUIn1Sel = 1'b1;
                ALUIn2Sel = 2'b10;
                PCSel = 2'bx;
                MtoRFSel = 1'bx; 
                RFDSel = 1'bx;
                IDSel = 1'bx;
            end
            S3: begin // MemRead
                IRWE = 0;
                MWE = 0;
                PCWE = 0; 
                Branch = 0; 
                RFWE = 0;
                ALUOp = 2'bx; 
                ALUIn1Sel = 1'bx;
                ALUIn2Sel = 2'bx;
                PCSel = 2'bx;
                MtoRFSel = 1'bx; 
                RFDSel = 1'bx;
                IDSel = 1'b1;
            end
            S4: begin // Mem Writeback
                IRWE = 0;
                MWE = 0;
                PCWE = 0; 
                Branch = 0; 
                RFWE = 1;
                ALUOp = 2'bx; 
                ALUIn1Sel = 1'bx;
                ALUIn2Sel = 2'bx;
                PCSel = 2'bx;
                MtoRFSel = 1'b1; 
                RFDSel = 1'b0;
                IDSel = 1'bx;
            end
            S5: begin // DMWE
                IRWE = 0;
                MWE = 1;
                PCWE = 0; 
                Branch = 0; 
                RFWE = 0;
                ALUOp = 2'bx; 
                ALUIn1Sel = 1'bx;
                ALUIn2Sel = 2'bx;
                PCSel = 2'bx;
                MtoRFSel = 1'bx; 
                RFDSel = 1'bx;
                IDSel = 1'b1;
            end
            S6: begin // Execute
                IRWE = 0;
                MWE = 0;
                PCWE = 0; 
                Branch = 0; 
                RFWE = 0;
                ALUOp = 2'b10; 
                ALUIn1Sel = 1'b1;
                ALUIn2Sel = 2'b00;
                PCSel = 2'bx;
                MtoRFSel = 1'bx; 
                RFDSel = 1'bx;
                IDSel = 1'bx;
            end
            S7: begin // ALU Writeback
                IRWE = 0;
                MWE = 0;
                PCWE = 0; 
                Branch = 0; 
                RFWE = 1;
                ALUOp = 2'bx; 
                ALUIn1Sel = 1'bx;
                ALUIn2Sel = 2'bx;
                PCSel = 2'bx;
                MtoRFSel = 1'b0; 
                RFDSel = 1'b1;
                IDSel = 1'bx;
            end
            S8: begin // Branch
                IRWE = 0;
                MWE = 0;
                PCWE = 0; 
                Branch = 1; 
                RFWE = 0;
                ALUOp = 2'b01; 
                ALUIn1Sel = 1'b1;
                ALUIn2Sel = 2'b00;
                PCSel = 2'b01;
                MtoRFSel = 1'bx; 
                RFDSel = 1'bx;
                IDSel = 1'bx;
            end
            S9: begin // Jump
                IRWE = 0;
                MWE = 0;
                PCWE = 1; 
                Branch = 0; 
                RFWE = 0;
                ALUOp = 2'bx; 
                ALUIn1Sel = 1'bx;
                ALUIn2Sel = 2'bx;
                PCSel = 2'b10;
                MtoRFSel = 1'bx; 
                RFDSel = 1'bx;
                IDSel = 1'bx;
            end
            S10: begin // ADDI Execute
                IRWE = 0;
                MWE = 0;
                PCWE = 0; 
                Branch = 0; 
                RFWE = 0;
                ALUOp = 2'b00; 
                ALUIn1Sel = 1'b1;
                ALUIn2Sel = 2'b10;
                PCSel = 2'bx;
                MtoRFSel = 1'bx; 
                RFDSel = 1'bx;
                IDSel = 1'bx;
            end
            S11: begin // ADDI Writeback
                IRWE = 0;
                MWE = 0;
                PCWE = 0; 
                Branch = 0; 
                RFWE = 1;
                ALUOp = 2'bx; 
                ALUIn1Sel = 1'bx;
                ALUIn2Sel = 2'bx;
                PCSel = 2'bx;
                MtoRFSel = 1'b0; 
                RFDSel = 1'b0;
                IDSel = 1'bx;
            end
        endcase
    end
    
endmodule
