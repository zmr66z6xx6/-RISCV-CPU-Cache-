`timescale 1ns / 1ps


module Forward_detect(//需要得到的是
    input [4:0]opcode,rdM,rdW,rs1,rs2,
    input regwriteM,regwriteW,
    output reg[1:0] forwardA,forwardB
);
    always@(*)begin
        if(regwriteM && (rdM != 5'b0) && (rdM == rs1))forwardA<=2'b10;
        else if(regwriteW && (rdW != 5'b0) && (rdW == rs1))forwardA<=2'b01;
        else forwardA<=2'b00;
        
        if(regwriteM && (rdM != 5'b0) && (rdM == rs2))forwardB<=2'b10;
        else if(regwriteW && (rdW != 5'b0) && (rdW == rs2))forwardB<=2'b01;
        else forwardB<=2'b00;
    end
    
endmodule
