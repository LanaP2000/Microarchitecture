`timescale 1ns / 1ps

module InstructionMemory #(parameter AWL = 6, DWL = 32, DEPTH = 2**AWL)
                          (input [AWL-1:0] IMA,
                           output reg [DWL-1:0] IMRD);
                           
reg [DWL-1:0] ROM [0:DEPTH-1];     

    // initial $readmemb("LW.mem", ROM); 
    // initial $readmemb("LW_SW.mem", ROM); 
    // initial $readmemb("LW_SW_R.mem", ROM); 
    // initial $readmemb("LW_SW_R_I.mem", ROM); 
    initial $readmemb("LW_SW_R_I_J.mem", ROM);              

    always @ (*) begin
        IMRD = ROM[IMA];
    end        
                           
endmodule
