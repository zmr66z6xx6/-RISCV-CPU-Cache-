`timescale 1ns / 1ps



module ID(
        input clk,rst,hazard,flush,pc_rs1_sel,memread,regwrite,memwrite,alusrc,regsrc,memhazard,
        input [31:0]pc,instr,predictpc,
        input [3:0]alucontrol,
        input [2:0]immsel,
        
        output reg [31:0]pcE,predictpcE,imm,
        output reg regwriteE,regsrcE,memreadE,memwriteE,alusrcE,branch,pc_rs1_selE,
        output reg [3:0]alucontrolE,
        output reg [4:0]rs1,rs2,rdE,opcode,
        output reg [2:0]f3
    );
    
    always@(posedge clk)begin
        if(rst)begin
            regwriteE<=1'b0;
            memreadE <=1'b0;
            memwriteE<=1'b0; 
            alusrcE<=1'b0;
            regsrcE <=1'b0;
            alucontrolE <= 4'b0;
            pcE<=32'b0;
            rs1<=5'bx;
            rs2<=5'bx;
            rdE<=5'b0;
            branch<=1'b0;
            opcode<=5'b0;
            pc_rs1_selE<=1'b0;
            f3<=3'b0;
            predictpcE<=32'b0;
            imm<=32'bx;
        end 
        else if(memhazard==1'b1)begin
            regwriteE<=regwriteE;
            memreadE <=memreadE;
            memwriteE<=memwriteE; 
            alusrcE<=alusrcE;
            regsrcE <=regsrcE;
            alucontrolE <= alucontrolE;
            pcE<=pcE;
            rs1<=rs1;
            rs1<=rs1;
            rdE<=rdE;
            branch<=branch;
            opcode<=opcode;
            pc_rs1_selE<=pc_rs1_selE;
            f3<=f3;
            predictpcE<=predictpcE;
            imm<=imm;
        end
        else begin
            if(flush==1'b1||hazard==1'b1)begin//hazard优先级应该是要高于error毕竟error在Hazard为真时可能是faker
                regwriteE<=1'bx;
                memreadE <=1'bx;
                memwriteE<=1'bx; 
                alusrcE<=1'bx;
                regsrcE <=1'bx;
                alucontrolE <= 4'bx;
                pcE<=32'bx;
                branch<=1'bx;
                opcode<=5'bx;
                pc_rs1_selE<=1'bx;
                f3<=3'bx;
                predictpcE<=32'bx;
                imm<=32'bx;
                rs1<=5'bx;
                rs2<=5'bx;
            end
            else begin
                regwriteE<=regwrite;
                memreadE <=memread;
                memwriteE<=memwrite; 
                alusrcE<=alusrc;
                regsrcE <=regsrc;
                alucontrolE <= alucontrol;
                pcE<=pc;
                rs1<=instr[19:15];
                rs2<=instr[24:20];
                rdE<=instr[11:7];
                if(instr[6:2]==5'b11000||instr[6:2]==5'b11011||instr[6:2]==5'b11001)branch<=1'b1;
                else branch<=1'b0;
                opcode<=instr[6:2];
                pc_rs1_selE<=pc_rs1_sel;
                f3<=instr[14:12];
                predictpcE<=predictpc;
                case(immsel)
                    3'b000:begin
                        imm={{20{instr[31]}},instr[31:20]};
                    end
                    3'b001:begin //特殊的5位立即数移位操作
                        imm={27'b0,instr[24:20]};
                    end
                    3'b010:begin
                        imm={{20{instr[31]}},instr[31:25],instr[11:7]};
                    end
                    3'b011:begin
                        imm={{20{instr[31]}},instr[31],instr[7],instr[30:25],instr[11:8]};
                    end
                    3'b100:begin//J指令
                        imm={{12{instr[31]}},instr[31],instr[19:12],instr[20],instr[30:21]};
                    end
                    3'b101:begin
                        imm={instr[31:12],{12{1'b0}}};
                    end
                    default:begin
                        imm=32'b0;
                    end
                endcase
            end
        end
    end
endmodule
