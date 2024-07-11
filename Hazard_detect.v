`timescale 1ns / 1ps


module Hazard_detect(//需要指令判断是否 数据冒险
    input memread,
    input [4:0] rs1, rs2, opcode, rd,
    output reg  hazard
    );
    always@(*)begin
        if(memread==1'b1 && rd!=5'b0)begin
            if(rs1==rd)begin
                if(opcode==5'b01100||opcode==5'b00100||opcode==5'b00000||opcode==5'b01000||opcode==5'b11000||opcode==5'b11001)hazard=1'b1;
                else hazard=1'b0; 
            end 
            else begin
                if(rs2!=rd)hazard=1'b0;
                else begin
                    if(opcode==5'b01100||opcode==5'b01000||opcode==5'b11000)hazard=1'b1;
                    else hazard=1'b0;
                end
            end
        end 
        else hazard =1'b0;
    end
endmodule
