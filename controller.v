`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/04 17:41:24
// Design Name: 
// Module Name: controller
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


module controller(
    input [31:0]instr, //regwrite regsrc memread memwrite pc_rs1_sel branch alusrc alucontrol(4)immsel(3) 共14位
    output [13:0]sigs
    );
    
    wire [1:0]aluop;
    main_control main_control(
        .opcode(instr[6:2]),
        .f3(instr[14:12]),
        
        .aluop(aluop),
        .regwrite(sigs[0]),
        .regsrc(sigs[1]),
        .memread(sigs[2]),
        .memwrite(sigs[3]),
        .pc_rs1_sel(sigs[4]),
        .branch(sigs[5]),
        .alusrc(sigs[6]),
        .immsel(sigs[13:11])
    );
    
    alu_control alu_control(
        .aluop(aluop),
        .f4({instr[30],instr[14:12]}),
        .alucontrol(sigs[10:7])
    );
    
endmodule
