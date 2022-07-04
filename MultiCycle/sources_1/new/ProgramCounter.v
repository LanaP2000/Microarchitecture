`timescale 1ns / 1ps

module ProgramCounter #(parameter AWL = 6, DWL = 32, DEPTH = 2**AWL)
                       (input CLK, EN,
                        input [DWL-1:0] PCp,
                        output reg [DWL-1:0] PC);
    
initial PC = 20;
    
    always @ (posedge CLK) begin
        if (EN)
            PC <= PCp;
    end
    
endmodule
