`timescale 1ns / 1ps


module EX(
        input clk,rst,regwrite,regsrc,memread,memwrite,memhazard,
        input [4:0]rd,
        input [31:0]ans,ans2,
        input [2:0]f3,
        
        output reg [2:0]f3M,
        output reg [31:0]B, aluout,
        output reg [4:0]rdM,
        output reg regsrcM,regwriteM,memreadM,memwriteM
);
    
    always@(posedge clk)begin
        if(rst)begin
            regsrcM<=1'b0;
            regwriteM<=1'b0;
            memreadM<=1'b0;
            memwriteM<=1'b0;
            aluout <=32'b0;
            B<=32'b0;
            rdM<=5'b0;
            f3M<=3'b0;
        end
        else if(memhazard==1'b1)begin
            regsrcM<=regsrcM;
            regwriteM<=regwriteM;
            memreadM<=memreadM;
            memwriteM<=memwriteM;
            aluout <=aluout;
            B<=B;
            rdM<=rdM;
            f3M<=f3M;
        end 
        else begin
            regsrcM<=regsrc;
            regwriteM<=regwrite;
            memreadM<=memread;
            memwriteM<=memwrite;
            aluout <=ans;
            B<=ans2;
            rdM<=rd;
            f3M<=f3;
        end
    end
endmodule
