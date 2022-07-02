`timescale 1ns / 1ps

module SingleCycle #(parameter AWL = 6, DWL = 32, DEPTH = 2**AWL)
                    (input CLK,
                     output [DWL-1:0] ALUDM);

wire [DWL-1:0] Inst, SImm;
wire [DWL-17:0] Imm;
wire [AWL-1:0] Funct;
wire [AWL-1:0] Opcode;
wire [DWL-7:0] Jaddr;
wire [AWL-2:0] Shamt;
wire [AWL-3:0] ALUSel;
wire Branch, Zero, PCSel;
wire [AWL-2:0] rs, rt, rd, rtd;
wire [DWL-1:0] MuxOut, PCp, PCp1, PCBranch, PCJump, PC;
wire [DWL-1:0] ALUIn1, ALUIn2, ALUOut, DMdin, DMOut;
wire MtoRFSel, DMWE, Branch, ALUInSel, RFDSel, RFWE, Jump;

assign Opcode = Inst[31:26];
assign rs = Inst[25:21];
assign rt = Inst[20:16];
assign rd = Inst[15:11];
assign Shamt = Inst[10:6];
assign Funct = Inst[5:0];
assign Imm = Inst[15:0];
assign Jaddr = Inst[25:0];
assign PCSel = Branch & Zero;
assign PCJump = {PCp1[31:26], Jaddr};


Mux                 #(.AWL(AWL-2), .DWL(DWL), .DEPTH(DEPTH)) 
                    UUT0 (.In1(PCBranch), .In2(PCp1), .Sel(PCSel), .Out(MuxOut));
    
Mux                 #(.AWL(AWL-2), .DWL(DWL), .DEPTH(DEPTH)) 
                    UUT1 (.In1(PCJump), .In2(MuxOut), .Sel(Jump), .Out(PCp));
    
ProgramCounter      #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH)) 
                    UUT2 (.CLK(CLK), .PCp(PCp), .PC(PC));
               
InstructionMemory   #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH)) 
                    UUT3 (.IMA(PC), .IMRD(Inst));
                    
Adder               #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH)) 
                    UUT4 (.In1(PC), .In2(1), .Out(PCp1));

ControlUnit         #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH)) 
                    UUT5 (.Opcode(Opcode), .Funct(Funct), .ALUSel(ALUSel), .MtoRFSel(MtoRFSel), .DMWE(DMWE), 
                          .Branch(Branch), .ALUInSel(ALUInSel), .RFDSel(RFDSel), .RFWE(RFWE), .Jump(Jump));

RegisterFile        #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH)) 
                    UUT6 (.CLK(CLK), .RFWE(RFWE), .RFWA(rtd), .RFRA1(rs), .RFRA2(rt), .RFWD(ALUDM), .RFRD1(ALUIn1), .RFRD2(DMdin));

Mux                 #(.AWL(AWL-2), .DWL(DWL-27), .DEPTH(DEPTH)) 
                    UUT7 (.In1(rd), .In2(rt), .Sel(RFDSel), .Out(rtd));
                    
SignExtensionUnit   #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))
                    UUT8 (.Imm(Imm), .SImm(SImm));

Mux                 #(.AWL(AWL-2), .DWL(DWL), .DEPTH(DEPTH)) 
                    UUT9 (.In1(SImm), .In2(DMdin), .Sel(ALUInSel), .Out(ALUIn2));

ArithmeticLogicUnit #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH)) 
                    UUT10 (.ALUIn1(ALUIn1), .ALUIn2(ALUIn2), .Shamt(Shamt), .ALUSel(ALUSel), .Zero(Zero), .ALUOut(ALUOut));

Adder               #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH)) 
                    UUT11 (.In1(Imm), .In2(PCp1), .Out(PCBranch));

DataMemory          #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH)) 
                    UUT12 (.CLK(CLK), .DMWE(DMWE), .DMWA(ALUOut), .DMWD(DMdin), .DMRD(DMOut));

Mux                 #(.AWL(AWL-2), .DWL(DWL), .DEPTH(DEPTH)) 
                    UUT13(.In1(DMOut), .In2(ALUOut), .Sel(MtoRFSel), .Out(ALUDM));
    
endmodule
