`timescale 1ns / 1ps

// RF in read-first mode
module RegisterFile #(parameter AWL = 6, DWL = 32, DEPTH = 2**AWL)
                     (input CLK, RFWE,
                      input [AWL-2:0] RFWA,
                      input [AWL-2:0] RFRA1, RFRA2,
                      input [DWL-1:0] RFWD,
                      output [DWL-1:0] RFRD1, RFRD2);
                      
reg [DWL-1:0] Registers [0:DEPTH-1];
integer i;

    initial begin
        for (i = 0; i < DEPTH; i = i + 1)
            Registers[i] = 0;
    end

    always @ (negedge CLK) begin
        if (RFWE) begin
            Registers[RFWA] <= RFWD;
        end
    end
    
    assign RFRD1 = Registers[RFRA1]; 
    assign RFRD2 = Registers[RFRA2];
                      
endmodule
