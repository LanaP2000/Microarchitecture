`timescale 1ns / 1ps

module DataMemory #(parameter AWL = 6, DWL = 32, DEPTH = 2**AWL)
                   (input CLK, DMWE,
                    input [AWL-1:0] DMWA,
                    input [DWL-1:0] DMWD,
                    output [DWL-1:0] DMRD);
    
reg [DWL-1:0] RAM [0:DEPTH-1];

    initial $readmemb("InitialData.mem", RAM);

    always @ (posedge CLK) begin
        if (DMWE)
            RAM[DMWA] <= DMWD;
    end
    
    assign DMRD = RAM[DMWA];
    
endmodule
