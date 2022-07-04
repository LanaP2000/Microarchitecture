`timescale 1ns / 1ps

module MultiCycle #(parameter AWL = 6, DWL = 32, DEPTH = 2**AWL)
                   (input CLK, RST,
                    output [DWL-1:0] Out);
                    
wire [AWL-1:0] Opcode, Funct;
wire [DWL-1:0] SImm;
wire [DWL-17:0] Imm;
wire [AWL-5:0] ALUIn2Sel, PCSel;
wire [DWL-1:0] PCp, PC, Addr;
wire [DWL-1:0] a, b, A, B, MRD, IR, DR;
wire [AWL-2:0] rs, rd, rt, rtd;
wire [DWL-1:0] ALUOutR;
wire [DWL-1:0] ALUIn1, ALUIn2, ALUOut;
wire [AWL-2:0] Shamt;
wire [AWL-3:0] ALUSel;
wire [DWL-1:0] Jaddr;
wire Zero, PCEn, MtoRFSel, RFDSel, ALUIn1Sel, IDSel, IRWE, MWE, PCWE, Branch, RFWE;

assign Opcode = IR[31:26];
assign rs = IR[25:21];
assign rt = IR[20:16];
assign rd = IR[15:11];
assign Shamt = IR[10:6];
assign Funct = IR[5:0];
assign Imm = IR[15:0];
  
assign Jaddr = 21 + {PC[31:26], IR[25:0]};
assign BranchAndZero = Branch & Zero;
assign PCEn = BranchAndZero | PCWE;


ControlUnit         #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))
                    UUT0 (.CLK(CLK), .RST(RST), .Opcode(Opcode), .Funct(Funct), .MtoRFSel(MtoRFSel), 
                          .RFDSel(RFDSel), .IDSel(IDSel), .PCSel(PCSel), .ALUSel(ALUSel), 
                          .ALUIn1Sel(ALUIn1Sel), .ALUIn2Sel(ALUIn2Sel), .IRWE(IRWE), 
                          .MWE(MWE), .PCWE(PCWE), .Branch(Branch), .RFWE(RFWE)); 
    
ProgramCounter      #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))
                    UUT1 (.CLK(CLK), .EN(PCEn), .PCp(PCp), .PC(PC));
               
Mux_2x1             #(.AWL(AWL-2), .DWL(DWL), .DEPTH(DEPTH))
                    UUT2 (.In1(ALUOutR), .In2(PC), .Sel(IDSel), .Out(Addr));
               
Memory              #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))
                    UUT3 (.CLK(CLK), .MWE(MWE), .MRA(Addr), .MWD(B), .MRD(MRD));
               
InstructionRegister #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))
                    UUT4 (.CLK(CLK), .EN(IRWE), .D(MRD), .Q(IR));
              
Register            #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))
                    UUT5 (.CLK(CLK),  .D(MRD), .Q(DR));
               
Mux_2x1             #(.AWL(AWL-2), .DWL(DWL-27), .DEPTH(DEPTH))
                    UUT6 (.In1(rd), .In2(rt), .Sel(RFDSel), .Out(rtd));
               
Mux_2x1             #(.AWL(AWL-2), .DWL(DWL), .DEPTH(DEPTH))
                    UUT7 (.In1(DR), .In2(ALUOutR), .Sel(MtoRFSel), .Out(Out));
               
RegisterFile        #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))
                    UUT8 (.CLK(CLK), .RFWE(RFWE), .RFWA(rtd), .RFRA1(rs), .RFRA2(rt), 
                          .RFWD(Out), .RFRD1(a), .RFRD2(b));
               
Register_2x2        #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))
                    UUT9 (.CLK(CLK), .D1(a), .D2(b), .Q1(A), .Q2(B));
               
Mux_2x1             #(.AWL(AWL-2), .DWL(DWL), .DEPTH(DEPTH))
                    UUT10 (.In1(A), .In2(PC), .Sel(ALUIn1Sel), .Out(ALUIn1));  
                    
SignExtensionUnit   #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))
                    UUT11 (.Imm(Imm), .SImm(SImm));
               
Mux_3x1             #(.AWL(AWL-2), .DWL(DWL), .DEPTH(DEPTH))
                    UUT12 (.In1(SImm), .In2(1), .In3(B), .Sel(ALUIn2Sel), .Out(ALUIn2));      
               
ArithmeticLogicUnit #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))
                    UUT13 (.ALUIn1(ALUIn1), .ALUIn2(ALUIn2), .Shamt(Shamt), .ALUSel(ALUSel), 
                           .Zero(Zero), .ALUOut(ALUOut));
                    
Register            #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))
                    UUT14 (.CLK(CLK), .D(ALUOut), .Q(ALUOutR));
         
Mux_3x1             #(.AWL(AWL-2), .DWL(DWL), .DEPTH(DEPTH))
                    UUT15 (.In1(Jaddr), .In2(ALUOutR), .In3(ALUOut), .Sel(PCSel), .Out(PCp)); 
    
endmodule
