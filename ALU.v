`timescale 1ns / 1ps


module ALU(
    input [31:0]num1,//rs1
    input [31:0]num2,//rs2
    input [3:0]alucontrol,
    output reg [31:0]ans
    );
    wire signed [31:0]r1 = num1;
    wire signed [31:0]r2 = num2;
    always@(*)begin
        case(alucontrol)
            4'b0001:begin
                ans<=num1+num2;
            end
            4'b0010:begin
                ans<=num1-num2;
            end
            4'b0011:begin
                ans<=num1&num2;
            end
            4'b0100:begin
                ans<=num1|num2;
            end
            4'b0101:begin
                ans<=num1^num2;
            end
            4'b0110:begin
                ans<=num1<<num2;
            end
            4'b0111:begin
                ans<=num1>>num2;
            end
            4'b1000:begin
                ans<=$signed(num1)>>>num2;
            end
            4'b1001:begin
                ans<=(num1<num2)?32'b1:32'b0;
            end
            4'b1010:begin
                ans<=(r1<r2)?32'b1:32'b0;
            end
            4'b0000:begin
                ans<=num2; //主要是针对lui指令直接将立即数进行数据传递
            end
            default:begin
                ans<=32'b0;
            end
        endcase
    end
endmodule
