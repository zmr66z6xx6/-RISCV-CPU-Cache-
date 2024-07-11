`timescale 1ns / 1ps

module adder(
	input wire[31:0] a,b,
	output wire signed[31:0] y
    );
	wire signed [31:0]a1 = a;
	wire signed [31:0]b1 = b;
	assign y = a + b;
endmodule
