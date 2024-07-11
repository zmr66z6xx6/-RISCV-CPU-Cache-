`timescale 1ns / 1ps


module alu_control(
    input [1:0]aluop,//main控制的指令
    input [3:0]f4,//指令的f3ion字段
    output reg [3:0]alucontrol//输出的alu控制信号
    );
    always@(*)begin
        case(aluop)
            2'b11:begin
                alucontrol=4'b0000;//旁路
            end
            2'b10:begin
                case(f4)
                    4'b0000:begin
                        alucontrol=4'b0001;//add操作
                    end
                    4'b1000:begin
                        alucontrol=4'b0010;//sub操作
                    end
                    4'b0111:begin
                        alucontrol=4'b0011;//and操作
                    end
                    4'b0110:begin
                        alucontrol=4'b0100;//or操作
                    end
                    4'b0100:begin
                        alucontrol=4'b0101;//xor操作
                    end
                    4'b0001:begin
                        alucontrol=4'b0110;//sll操作
                    end
                    4'b0101:begin
                        alucontrol=4'b0111;//srl操作
                    end
                    4'b1101:begin
                        alucontrol=4'b1000;//sra操作
                    end
                    4'b0011:begin//无符号
                        alucontrol=4'b1001;//slt操作
                    end
                    4'b0010:begin//有符号的slt
                        alucontrol=4'b1010;
                    end
                    default:begin
                        alucontrol=4'bxxxx;
                    end
                endcase
            end
            2'b01:begin
                case(f4[2:0])
                    3'b000:begin
                        alucontrol=4'b0001;//add操作
                    end
                    3'b111:begin
                        alucontrol=4'b0011;//and操作
                    end
                    3'b110:begin
                        alucontrol=4'b0100;//or操作
                    end
                    3'b100:begin
                        alucontrol=4'b0101;//xor操作
                    end
                    3'b001:begin
                        alucontrol=4'b0110;//sll操作
                    end
                    3'b101:begin
                        if(f4[3]==1'b0)alucontrol=4'b0111;//srl操作
                        else alucontrol=4'b1000;
                    end
                    3'b011:begin//无符号
                        alucontrol=4'b1001;//slt操作
                    end
                    3'b010:begin//有符号的slt
                        alucontrol=4'b1010;
                    end
                    default:begin
                        alucontrol=4'bxxxx;
                    end
                endcase
            end
            2'b00:begin
                alucontrol=4'b0001;//add操作
            end
        endcase
    end
endmodule
