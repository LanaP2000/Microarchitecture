`timescale 1ns / 1ps

module SignExtensionUnit #(parameter AWL = 6, DWL = 32, DEPTH = 2**AWL)
                          (input [DWL-17:0] Imm,
                           output reg [DWL-1:0] SImm);
    
    always @ (*) begin
        SImm = {{16{Imm[15]}}, Imm};
    end

endmodule
