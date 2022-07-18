`timescale 1ns / 1ps

module tb_FIRFilter();

parameter WL1 = 4, WL2 = 4, WL = 4;
parameter ClockPeriod = 20;
reg CLK;
reg [WL-1:0] x;
wire [`WL_Mult:0] y;

FIRFilter #(.WL1(WL1), .WL2(WL2), .WL(WL)) 
          DUT (.CLK(CLK), .x(x), .y(y));
          
    initial begin : ClockGenerator
        CLK = 1'b0;
        forever #(ClockPeriod / 2) CLK = ~CLK;
    end
    
    initial begin : TestVectorGenerator
        @(posedge CLK) x <= 4'b1111; // -1
        @(posedge CLK) x <= 4'b1110; // -2
        @(posedge CLK) x <= 4'b0011; // 3 
        @(posedge CLK) x <= 4'b0100; // 4
        @(posedge CLK) x <= 4'b1011; // -5  
        @(posedge CLK) x <= 4'b0001; // 1
        @(posedge CLK) x <= 4'b0000; // 0
        @(posedge CLK) x <= 4'b0011; // 3
        @(posedge CLK) x <= 4'b0100; // 4
        @(posedge CLK) x <= 4'b0001; // 1
        @(posedge CLK) x <= 4'b0010; // 2
        @(posedge CLK) x <= 4'b0011; // 3
        @(posedge CLK) x <= 4'b0100; // 4
        @(posedge CLK) x <= 4'b0010; // 2
        @(posedge CLK) x <= 4'b1111; // -1
        @(posedge CLK) x <= 4'b0011; // 3
        @(posedge CLK) x <= 4'b0010; // 2
        @(posedge CLK) x <= 4'b0110; // 6
        @(posedge CLK) x <= 4'b0001; // 1
        @(posedge CLK) x <= 4'b1111; // -1
        @(posedge CLK) x <= 4'b1001; // 7 
        @(posedge CLK); @(posedge CLK);
        @(posedge CLK); @(posedge CLK);
        $finish;
    end

endmodule
