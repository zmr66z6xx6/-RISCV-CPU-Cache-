`timescale 1ns / 1ps

module sleft(
    input [31:0]data,
    output wire [31:0]sl_data
    );
    assign sl_data={data[30:0],1'b0};
endmodule