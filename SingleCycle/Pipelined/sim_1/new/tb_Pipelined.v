`timescale 1ns / 1ps

module tb_Pipelined();

parameter AWL = 6, DWL = 32, DEPTH = 2**AWL;
parameter ClockPeriod = 10;
reg CLK;
wire [DWL-1:0] Result;


Pipelined #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))
          DUT (.CLK(CLK), .ResultW(Result));
          
    initial begin : ClockGenerator
        CLK = 1'b0;
        forever #(ClockPeriod / 2) CLK = ~CLK;
    end
    

endmodule
