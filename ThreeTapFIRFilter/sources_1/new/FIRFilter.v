`timescale 1ns / 1ps

`define WL_Add  (WL1 > WL2) ? (WL1 + 1) : (WL2 + 1)
`define WL_Mult (WL1 > WL2) ? (2 * WL1) : (2 * WL2)

module FIRFilter #(parameter WL1 = 4, WL2 = 4, WL = 4,
                             h0 = 4'b1101,
                             h1 = 4'b0011,
                             h2 = 4'b0101)
                  (input CLK,
                   input signed [WL-1:0] x,
                   output signed [`WL_Mult:0] y);
 
wire [WL-1:0] x_q, x_q_q;
wire [`WL_Mult-1:0] h0x, h1x_q, h2x_q_q, h0xPh1x_q;

Register   #(.WL(WL))         
           UUT0 (.CLK(CLK), .D(x), .Q(x_q));
           
Register   #(.WL(WL))          
           UUT1 (.CLK(CLK), .D(x_q), .Q(x_q_q));
           
Multiplier #(.WL1(WL1), .WL2(WL2)) 
           UUT2 (.In1(h0), .In2(x), .Out(h0x));
           
Multiplier #(.WL1(WL1), .WL2(WL2)) 
           UUT3 (.In1(h1), .In2(x_q), .Out(h1x_q));
           
Multiplier #(.WL1(WL1), .WL2(WL2)) 
           UUT4 (.In1(h2), .In2(x_q_q), .Out(h2x_q_q));
           
Adder      #(.WL1(`WL_Mult), .WL2(`WL_Mult)) 
           UUT5 (.In1(h0x), .In2(h1x_q), .Out(h0xPh1x_q)); 
           
Adder      #(.WL1(`WL_Mult), .WL2(`WL_Mult)) 
           UUT6 (.In1(h0xPh1x_q), .In2(h2x_q_q), .Out(y)); 
    
endmodule
