`timescale 1ns / 1ps

module compare(
    // input branch,
    input [4:0]opcode,
    input [2:0]f3,//funct3进行跳转判断类型的确定
    input [31:0]rd1,
    input [31:0]rd2,
    output reg cmp
    );
    wire signed [31:0] a1 = rd1;
    wire signed [31:0] b1 = rd2;
    always@(*)begin
        if(rd1==32'bx)cmp=1'bx;
        else if(opcode==5'b11011||opcode==5'b11001)cmp=1'b1;
        else begin
            case(f3)
                3'b000: begin
                    if(rd1==rd2)cmp=1'b1;
                    else cmp=1'b0;
                end
                3'b101: begin
                    if(a1>=b1)cmp=1'b1;
                    else cmp =1'b0;
                end
                3'b111: begin
                    if(rd1>=rd2)cmp=1'b1;
                    else cmp=1'b0;
                end
                3'b100: begin
                    if(a1<b1)cmp=1'b1;
                    else cmp=1'b0;
                end
                3'b110: begin
                    if(rd1<rd2)cmp=1'b1;
                    else cmp=1'b0;
                end
                3'b001: begin
                    if(rd1!=rd2)cmp=1'b1;
                    else cmp=1'b0;
                end
                default:begin
                    cmp = 1'b0;
                end
            endcase
        end
    end
endmodule
