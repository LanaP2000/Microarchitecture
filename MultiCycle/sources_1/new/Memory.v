`timescale 1ns / 1ps

module Memory #(parameter AWL = 6, DWL = 32, DEPTH = 2**AWL)
               (input CLK, MWE,
                input [AWL-1:0] MRA,
                input [DWL-1:0] MWD,
                output [DWL-1:0] MRD);
    
reg [DWL-1:0] RAM [0:DEPTH-1];
    
    // initial $readmemb("Data_LW.mem", RAM); 
    // initial $readmemb("Data_LW_SW.mem", RAM); 
    // initial $readmemb("Data_LW_SW_R.mem", RAM); 
    // initial $readmemb("Data_LW_SW_R_I.mem", RAM); 
    initial $readmemb("Data_LW_SW_R_I_J.mem", RAM); 
    
    always @ (posedge CLK) begin
        if (MWE)
            RAM[MRA] <= MWD;
    end
    
    assign MRD = RAM[MRA];
    
endmodule
