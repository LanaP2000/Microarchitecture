`timescale 1ns / 1ps

module Register_12x12 #(parameter AWL = 6, DWL = 32, DEPTH = 2**AWL)
                       (input CLK, CLR,
                        input D1, D2, D3, 
                        input [AWL-3:0] D4, 
                        input D5, D6,
                        input [DWL-1:0] D7, D8, 
                        input [AWL-2:0] D9, D10, D11, 
                        input [DWL-1:0] D12,
                        input [AWL-2:0] D13,
                        output reg Q1, Q2, Q3, 
                        output reg [AWL-3:0] Q4, 
                        output reg  Q5, Q6,
                        output reg [DWL-1:0] Q7, Q8, 
                        output reg [AWL-2:0] Q9, Q10, Q11, 
                        output reg [DWL-1:0] Q12,
                        output reg [AWL-2:0] Q13);
                        
    always @ (posedge CLK) begin
        Q1  <= D1;
        Q2  <= D2;
        Q3  <= D3;
        Q4  <= D4;
        Q5  <= D5;
        Q6  <= D6;
        Q7  <= D7;
        Q8  <= D8;
        Q9  <= D9;
        Q10 <= D10;
        Q11 <= D11;
        Q12 <= D12;
        Q13 <= D13;
        if (CLR) begin
            Q1  <= 0;
            Q2  <= 0;
            Q3  <= 0;
            Q4  <= 0;
            Q5  <= 0;
            Q6  <= 0;
            Q7  <= 0;
            Q8  <= 0;
            Q9  <= 0;
            Q10 <= 0;
            Q11 <= 0;
            Q12 <= 0;
            Q13 <= 0;
        end
    end         
                        
endmodule
