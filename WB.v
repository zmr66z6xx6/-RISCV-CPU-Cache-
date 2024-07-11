`timescale 1ns / 1ps


module WB(
	input clk,memhazard,
	input wena,//写使能
	input [4:0] rs1,rs2,wrd,
	input [31:0] wdata,//写数据
	output reg [31:0] rd1,rd2
    );
	reg [31:0] rf[31:0];//深度为32的寄存器
	always @(posedge clk) begin
		if(memhazard==1'b1)begin
			rd1<=rd1;
			rd2<=rd2;
		end
		else begin
			if(wena) begin
				rf[wrd] <= wdata;
			end
			if(rs1==5'bx)rd1<=32'bx;
			else if(rs1==5'b0)rd1<=32'b0;
			else if(rs1==wrd)rd1<=wdata;
			else rd1<=rf[rs1];
			
			if(rs2==5'bx)rd2<=32'bx;
			else if(rs2==5'b0)rd2<=32'b0;
			else if(rs2==wrd)rd2<=wdata;
			else rd2<=rf[rs2];
		end
	end
	
endmodule

