`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/04 17:13:46
// Design Name: 
// Module Name: riscv
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module riscv(
    input clk,rst,
    output [31:0]memwdata,memaddra,pc,dest,//dest为实际预测的目标地址 错误与否
    output memreadM,memwriteM,error
    );
    
    wire [31:0]instr;
    wire [13:0]sigs;
    wire [4:0]rdE,rdM,rdW,rs1,rs2,opcodeE;
    wire hazard,memreadE,regwriteM,regwriteW;
    wire [1:0]forwardA,forwardB;
    
    controller controller(
        .instr(instr), //regwrite regsrc memread memwrite pc_rs1_sel branch alusrc alucontrol(4)immsel(3) 共14位
        .sigs(sigs)
    );
    
    datapath datapath(
        .clk(clk),
        .rst(rst),
        .hazard(hazard),
        .sigs(sigs),//regwrite regsrc memread memwrite pc_rs1_sel branch alusrc alucontrol(4)immsel(3) 共14位
        .forwardA(forwardA),
        .forwardB(forwardB),
        
        .instr(instr),
        .rd2M(memwdata),
        .npc(pc),
        .dest(dest),
        .error(error),
        .aluoutM(memaddra),
        .memreadM(memreadM),
        .memwriteM(memwriteM),
        .memreadE(memreadE),
        .opcodeE(opcodeE),
        .regwriteM(regwriteM),
        .regwriteW(regwriteW),
        .rdE(rdE),
        .rdM(rdM),
        .rdW(rdW),
        .rs1(rs1),
        .rs2(rs2)
    );
    
    Hazard_detect Hazard_detect(
        .opcode(instr[6:2]),
        .memread(memreadE),
        .rd(rdE),
        .rs1(instr[19:15]),
        .rs2(instr[24:20]),
        
        .hazard(hazard)
    );
    
    Forward_detect Forward_detect(
        .opcode(opcodeE),
        .rdM(rdM),
        .rdW(rdW),
        .rs1(rs1),
        .rs2(rs2),
        .regwriteM(regwriteM),
        .regwriteW(regwriteW),
        
        .forwardA(forwardA),
        .forwardB(forwardB)
    );

endmodule
