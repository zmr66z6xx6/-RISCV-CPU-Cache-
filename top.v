`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/04 17:09:57
// Design Name: 
// Module Name: top
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


module top(
    input clk,rst,
    output [31:0]memwdata,memaddra
);
    
    wire [31:0]pc,dest;
    wire memreadM,memwriteM,error;
    riscv riscv(
        .clk(clk),
        .rst(rst),
                
        .memwdata(memwdata),
        .memaddra(memaddra),
        .pc(pc),
        .dest(dest),//dest为实际预测的目标地址
        .memreadM(memreadM),
        .memwriteM(memwriteM),
        .error(error)
    );
    
endmodule
