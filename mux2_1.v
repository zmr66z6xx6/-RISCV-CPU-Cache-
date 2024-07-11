`timescale 1ns / 1ps

module mux2_1#(parameter width=32)(
    input [width-1:0] a,//pc+4
    input [width-1:0] b,//pc+offset
    input op,
    output wire [width-1:0] c
    );

    assign c=(op==1'b1)?a:b;
endmodule