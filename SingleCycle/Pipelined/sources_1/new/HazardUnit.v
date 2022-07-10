`timescale 1ns / 1ps

module HazardUnit #(parameter AWL = 6, DWL = 32, DEPTH = 2**AWL)
                   (input BranchD,
                    input [AWL-2:0] RsD, RtD, RsE, RtE, RFAE, RFAM, RFAW,
                    input MtoRFSelE, MtoRFSelM, RFWEE, RFWEM, RFWEW,
                    output reg Stall, Flush, 
                    output reg [AWL-5:0] ForwardAD, ForwardBD,
                    output reg [AWL-5:0] ForwardAE, ForwardBE);
 
reg LWStall, BRStall;

initial Stall = 0;
initial LWStall = 0;
initial BRStall = 0;
initial ForwardAD = 2'b00;
initial ForwardBD = 2'b00;
initial ForwardAE = 2'b00;
initial ForwardBE = 2'b00;

    
    always @ (*) begin
        // ForwardAD = (RsD != 0) && (RsD == RFAM) && RFWEM;
        if ((RsD != 0) && (RsD == RFAM) && RFWEM)
            ForwardAD = 1;
        else
            ForwardAD = 0;
        
        // ForwardBD = (RtD != 0) && (RtD == RFAM) && RFWEM;
        if ((RtD != 0) && (RtD == RFAM) && RFWEM)
            ForwardBD = 1;
        else
            ForwardBD = 0;
    end          
                    
    always @ (*) begin
        if ((RsE != 0) && RFWEM && (RsE == RFAM))
            ForwardAE = 2'b10;
        else if ((RsE != 0) && RFWEW && (RsE == RFAW))
            ForwardAE = 2'b01;
        else
            ForwardAE = 2'b00;
    end       
    
    always @ (*) begin
        if ((RtE != 0) && RFWEM && (RtE == RFAM))
            ForwardBE = 2'b10;
        else if ((RtE != 0) && RFWEW && (RtE == RFAW))
            ForwardBE = 2'b01;
        else
            ForwardBE = 2'b00;
    end  
    
    always @ (*) begin
        // LWStall = MtoRFSelE && ((RtE == RsD) || (RtE == RtD)); 
        if (MtoRFSelE && ((RtE == RsD) || (RtE == RtD))) 
            LWStall = 1;
        else
            LWStall = 0;
            
        // BRStall = (RsD == RFAE || RtD == RFAE) && BranchD && RFWEE ||
        //           (RsD == RFAM || RtD == RFAM) && BranchD && MtoRFSelM;
        if ((RsD == RFAE || RtD == RFAE) && BranchD && RFWEE ||
            (RsD == RFAM || RtD == RFAM) && BranchD && MtoRFSelM)
            BRStall = 1;
        else
            BRStall = 0;
        
        // Stall = LWStall || BRStall;
        if (LWStall || BRStall)
            Stall = 1;
        else
            Stall = 0;
        Flush = Stall;
    end     
                    
endmodule
