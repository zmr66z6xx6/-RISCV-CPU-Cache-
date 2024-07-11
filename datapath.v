`timescale 1ns / 1ps

module datapath(
        input clk, rst, hazard,
        input [13:0]sigs,//regwrite regsrc memread memwrite pc_rs1_sel branch alusrc alucontrol(4)immsel(3) 共14位
        output [1:0]forwardA,forwardB,
        
        output [31:0]instr,rd2M,npc,dest,aluoutM,
        output error,memreadM,memwriteM, memreadE,regwriteM,regwriteW,
        output [4:0]opcodeE,rdE,rdM,rdW,rs1,rs2
    );
    
    wire [31:0]pc,pcE,predictpcE,ldata,regwritedata,rd1,rd2,imm,tpc,immsl1,r1,aluoutW,r11,r2,r22,r222,rd2true,rd1true,ans,Btrue1,Btrue2,tdest;
    wire regwriteE,regsrcE,memwriteE,alusrcE,branchE,pc_rs1_selE,regsrcW,regsrcM,cmp,jump,memreadW,memhazard;//访存停顿
    wire [3:0]alucontrolE;
    wire [2:0]f3E,f3M;
    
    IF IF(
        .clk(clk),
        .rst(rst),
        .error(error),
        .jump(jump),
        .lastpc(pcE),
        .dest(dest/4),
        .hazard(hazard),
        .memhazard(memhazard),
        
        .pc(pc),
        .npc(npc),
        .instr(instr)
    );
    
    ID ID(
        .clk(clk),
        .rst(rst),
        .pc(pc),
        .instr(instr),
        .hazard(hazard),
        .flush(error),
        .pc_rs1_sel(sigs[4]),
        .memread(sigs[2]),
        .regwrite(sigs[0]),
        .memwrite(sigs[3]),
        .alusrc(sigs[6]),
        .regsrc(sigs[1]),
        .alucontrol(sigs[10:7]),
        .predictpc(npc),
        .immsel(sigs[13:11]),
        .memhazard(memhazard),
        
        .predictpcE(predictpcE),
        .pcE(pcE),
        .regwriteE(regwriteE),
        .regsrcE(regsrcE),
        .memreadE(memreadE),
        .memwriteE(memwriteE),
        .alusrcE(alusrcE),
        .alucontrolE(alucontrolE),
        .rs1(rs1),
        .rs2(rs2),
        .rdE(rdE),
        .branch(branchE),
        .opcode(opcodeE),
        .pc_rs1_selE(pc_rs1_selE),
        .f3(f3E),
        .imm(imm)
    );
    
    mux2_1 m1(.b(aluoutW),.a(ldata),.op(regsrcW),.c(regwritedata));
    WB WB(
        .clk(clk),
        .wena(regwriteW),
        .wrd(rdW),
        .wdata(regwritedata),
        .rs1(instr[19:15]),
        .rs2(instr[24:20]),
        .memhazard(memhazard),
        
        .rd1(rd1),
        .rd2(rd2)
    );
    
    mux2_1 m2(.a(rd1),.b(pcE*4),.op(pc_rs1_selE),.c(tpc));
    sleft sleft(.data(imm),.sl_data(immsl1));
    
    adder adder(.a(tpc),.b(immsl1),.y(tdest));
    assign dest=(branchE==1'b1&&cmp==1'b1)?tdest:4*pcE+32'd4;
    
    mux2_1 m3(.b(rd1),.a(aluoutM),.op(forwardA[1]),.c(r1));
    wire [31:0]t1,t2;
    mux2_1 m12(.b(aluoutW),.a(ldata),.op(memreadW==1'b1),.c(t1));
    mux2_1 m4(.b(r1),.a(t1),.op(forwardA[0]),.c(r11));
    mux2_1 m5(.b(rd2),.a(aluoutM),.op(forwardB[1]),.c(r2));
    mux2_1 m13(.b(aluoutW),.a(ldata),.op(memreadW==1'b1),.c(t2));
    mux2_1 m6(.b(r2),.a(t2),.op(forwardB[0]),.c(r22));
    mux2_1 m7(.b(r22),.a(imm),.op(alusrcE),.c(r222));
    
    mux2_1 m8(.b(r11),.a(4*pcE),.op((opcodeE==5'b00101)?1'b1:1'b0),.c(rd1true));
    mux2_1 m9(.b(r222),.a(4*pcE+32'd4),.op((opcodeE==5'b11011||opcodeE==5'b11001)?1'b1:1'b0),.c(rd2true));
    
    ALU alu(.num1(rd1true),.num2(rd2true),.alucontrol(alucontrolE),.ans(ans));
    
    //对于store的特殊性 要进行一个特殊选择
    mux2_1 m10(.b(rd2),.a(aluoutM),.op(forwardB[1]),.c(Btrue1));
    mux2_1 m11(.b(Btrue1),.a(aluoutW),.op(forwardB[0]),.c(Btrue2));
    
    EX EX(
        .clk(clk),
        .rst(rst),
        .rd(rdE),
        .ans(ans),
        .ans2(Btrue2),//针对B的传送
        .regwrite(regwriteE),
        .regsrc(regsrcE),   
        .memread(memreadE),    
        .memwrite(memwriteE),
        .f3(f3E),
        .memhazard(memhazard),
        
        .B(rd2M),
        .aluout(aluoutM),
        .rdM(rdM),
        .regsrcM(regsrcM),
        .regwriteM(regwriteM),
        .memreadM(memreadM),
        .memwriteM(memwriteM),
        .f3M(f3M)
    );
    
    compare compare(
        .opcode(opcodeE),
        .f3(f3E),
        .rd1(rd1true),
        .rd2(rd2true),
        .cmp(cmp)
    );
    
    assign jump = (cmp==1'b1 && branchE==1'b1)?1'b1:1'b0; 
    assign error = ((branchE==1'b0 && predictpcE==pcE+1)||predictpcE==1'bx)?1'b0:
    (branchE==1'b1 && cmp==1'b1 && dest/4==predictpcE)?1'b0:
    (branchE==1'b1 && cmp==1'b0 && dest/4==predictpcE)?1'b0:1'b1;
    
    MEM MEM(
      .clk(clk),
      .rst(rst),
      .regsrc(regsrcM),
      .regwrite(regwriteM),
      .memread(memreadM),
      .memwrite(memwriteM),
      .rd(rdM),
      .aluout(aluoutM),
      .B(rd2M),
      .f3(f3M),
      
      .memreadW(memreadW),
      .rdW(rdW),
      .regsrcW(regsrcW),
      .regwriteW(regwriteW),
      .ldata(ldata),
      .aluoutW(aluoutW),
      .hazard(memhazard)
    );
    
endmodule