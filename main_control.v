`timescale 1ns / 1ps


module main_control(
    input [4:0]opcode,
    input [2:0]f3,
    output reg [1:0]aluop,
    output reg regwrite,regsrc,memread,memwrite,pc_rs1_sel,branch,alusrc,
    output reg [2:0]immsel
);
    always@(*)begin
        case(opcode)
            5'b01100:begin//R
                aluop=2'b10;
                regwrite=1'b1;
                memwrite=1'b0;
                regsrc=1'b0;//直接拿到 aluresult的结果存回寄存器堆中
                memread=1'b0;
                immsel=3'b0;//不需要用到符号位的扩展
                alusrc=1'b0;//0是寄存器操作数
                pc_rs1_sel=1'b0;
                branch<=1'b0;
            end
            5'b00100:begin ///立即数运算
                aluop=2'b01;
                regwrite=1'b1;
                memwrite=1'b0;
                regsrc=1'b0;
                memread=1'b0;
                case(f3)
                    3'b101:begin
                        immsel=3'b001;
                    end
                    3'b001:begin
                        immsel=3'b001;
                    end
                    default:begin
                        immsel=3'b000;
                    end
                endcase
                alusrc=1'b1;
                pc_rs1_sel=1'b0;
                branch<=1'b0;
            end
            5'b00000:begin //ld指令
                aluop=2'b00;
                regwrite=1'b1;
                memwrite=1'b0;
                regsrc=1'b1;
                memread=1'b1;
                immsel=3'b000;
                alusrc=1'b1;
                pc_rs1_sel=1'b0;
                branch<=1'b0;
            end
            5'b01000:begin //store指令
                aluop=2'b00;
                regwrite=1'b0;
                memwrite=1'b1;
                regsrc=1'b0;
                memread=1'b0;
                immsel=3'b010;
                alusrc=1'b1;
                pc_rs1_sel=1'b0;
                branch<=1'b0;
            end
            5'b11000:begin  //分支
                aluop=2'b00; //分支无所谓了，因为我们的分支又单独的比较模块，不需要
                regwrite=1'b0;
                memwrite=1'b0;
                regsrc=1'b0;
                memread=1'b0;
                immsel=3'b011;
                alusrc=1'b0;
                pc_rs1_sel=1'b0;
                branch<=1'b1;
            end
            5'b11011:begin//J指令立即数扩展编码为4
                aluop=2'b11; //无需计算直接旁路
                regwrite=1'b1;
                memread=1'b0;
                memwrite=1'b0;
                regsrc=1'b0;
                alusrc=1'b0;
                immsel= 3'b100;
                pc_rs1_sel=1'b0;    
                branch<=1'b1;   
            end
            5'b11001:begin//jalr
                aluop=2'b11; //无需计算直接旁路
                regwrite=1'b1;
                regsrc=1'b0;
                memread=1'b0;
                memwrite=1'b0;
                alusrc=1'b0;
                immsel=3'b100;
                pc_rs1_sel=1'b1;
                branch<=1'b1;
            end
            5'b01101:begin///U立即数编号5
                aluop=2'b11;//旁路直接拿去第二个数据
                regwrite=1'b1;
                memwrite=1'b0;
                regsrc=1'b1;
                memread=1'b0;
                immsel=3'b101;
                alusrc=1'b1;
                pc_rs1_sel=1'b0;
                branch<=1'b0;
            end
            5'b00101:begin//立即数编号5
                aluop=2'b00;
                regwrite=1'b1;
                memwrite=1'b0;
                regsrc=1'b0;
                memread=1'b0;
                immsel=3'b101;
                alusrc=1'b1;
                pc_rs1_sel=1'b0;
                branch<=1'b0;
            end
            default:begin
                aluop=2'b00;
                regwrite=1'b0;
                memwrite=1'b0;
                regsrc=1'b0;
                memread=1'b0;
                immsel=3'b000;
                alusrc=1'b0;
                pc_rs1_sel=1'b0;
                branch<=1'b0;
            end
        endcase
    end
endmodule