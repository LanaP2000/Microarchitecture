`timescale 1ns / 1ps

module tb_MultiCycle();
 
parameter AWL = 6, DWL = 32, DEPTH = 2**AWL; 
parameter ClockPeriod = 8;   
reg CLK, RST;
wire [DWL-1:0] Out;


MultiCycle #(.AWL(AWL), .DWL(DWL), .DEPTH(DEPTH))
           DUT (.CLK(CLK), .RST(RST), .Out(Out));
           
    initial begin : ClockGenerator
        CLK = 1'b1;
        forever #(ClockPeriod / 2) CLK = ~CLK;
    end
    
    initial begin
        RST = 1;
        @(posedge CLK) RST = 0;
    end
    
endmodule
