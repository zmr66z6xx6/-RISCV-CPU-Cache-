`timescale 1ns / 1ps


module MEM(
    input clk,rst,regsrc,regwrite,memread,memwrite,
    input [4:0]rd,
    input [31:0]aluout,B,
    input [2:0]f3,

    output reg[4:0]rdW,
    output reg regsrcW,regwriteW,memreadW,hazard,
    output reg[31:0]ldata,aluoutW
);

    reg [9:0]address;
    reg [31:0]dirty_data;
    reg dirty_write;
    reg [31:0]D_cache[127:0];
    reg [0:0]dirty[127:0];
    reg [0:0]valid[127:0];
    reg [22:0]tag[127:0];
    reg hazard_again,rmiss,wmiss;
    wire [6:0]index;
    wire [31:0]m_data;
    assign index=aluout[8:2];
    
    always@(*)begin
        if(memread==1'b1&&valid[index]==1'b1&&tag[index]==aluout[31:9])rmiss<=1'b0;
        else if(memread==1'b1) rmiss<=1'b1;
        else rmiss<=1'b0;
        if(memwrite==1'b1&&valid[index]==1'b1&&tag[index]!=aluout[31:9])wmiss<=1'b1;
        else wmiss<=1'b0;
    end
    
    always@(*)begin
        if(rmiss==1'b1)hazard<=1'b1;
        else if(hazard_again==1'b1)hazard<=1'b1;
        else begin
            hazard<=1'b0;
            if(wmiss==1'b1)begin 
                dirty_data<=D_cache[index];
                if(dirty[index]==1'b1)dirty_write<=1'b1;
                else dirty_write<=1'b0;
            end
            else begin
                dirty_write<=1'b0;
            end
        end
    end

    //assign address = (wmiss==1'b1)? {tag[index][0],index,{2'b00}}:aluout[9:0];
    
    always@(*)begin
        if(hazard_again==1'b1)address<=address;
        else begin
            if(wmiss==1'b1)address<={tag[index][0],index,{2'b00}};
            else address<=aluout[9:0];
        end
    end
    
    
    wire anotherena;
    assign anotherena = (dirty_write==1'b1)?1'b1:rmiss; 
    BM Dmem(
        .clka(clk),    // input wire clka
        .ena(anotherena),      // input wire ena
        .wea(dirty_write),      // input wire [0 : 0] wea
        .addra(address),  // input wire [9 : 0] addra
        .dina(dirty_data),    // input wire [31 : 0] dina
        .douta(m_data)  // output wire [31 : 0] douta
    );
    
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            regsrcW<=1'b0;
            regwriteW<=1'b0;
            ldata<=32'b0;
            aluoutW<=32'b0;
            rdW<=5'b0;
            memreadW<=1'b0;
            // D_cache[1020]<=32'd1;
            D_cache[0]<=32'd3;
            // D_cache[1016]<=32'd3;
            D_cache[4]<=32'd10;
            // D_cache[1012]<=32'd16;
            D_cache[8]<=32'd0;
            // D_cache[1008]<=32'd2;
            // D_cache[12]<=32'd7; 
            // D_cache[1004]<=32'd7;
            // D_cache[16]<=32'd9;
            // D_cache[1000]<=32'd4;
            // D_cache[20]<=32'd5;
            // D_cache[996]<=32'd12;
            // D_cache[24]<=32'd18;
            // D_cache[992]<=32'd6;
            // D_cache[28]<=32'd8;
        end
        else begin
            if(hazard_again==1'b1)begin
                hazard_again<=1'b0;
                dirty_write<=1'b0;
                D_cache[index]<=m_data;
                dirty[index]<=1'b0;
            end
            else if(hazard==1'b1)begin
                hazard_again<=1'b1;
                if(dirty[index]==1'b1)begin //是脏数据才要写回内存 地址记得别用错了
                    dirty_write<=1'b1;
                    address<={tag[index][0],index,{2'b00}};
                end
                else dirty_write<=1'b0;
                dirty_data<=D_cache[index];
                tag[index]<=aluout[31:9];
                valid[index]<=1'b1;
            end
            else begin//无读缺失的情况下
                dirty_write<=1'b0;//
                memreadW<=memread;
                regsrcW<=regsrc;
                regwriteW<=regwrite;
                aluoutW<=aluout;
                rdW<=rd;
                if(memread==1'b1)begin
                    case(f3)
                        3'b000:begin
                            ldata<={{24{D_cache[index][7]}},D_cache[index][7:0]};
                        end
                        3'b001:begin
                            ldata<={{16{D_cache[index][15]}},D_cache[index][15:0]};
                        end
                        3'b010:begin
                            ldata<=D_cache[index][31:0];
                        end
                        3'b100:begin
                            ldata<={{24{1'b0}},D_cache[index][7:0]};
                        end
                        3'b101:begin
                            ldata<={{16{1'b0}},D_cache[index][15:0]};
                        end
                        default:begin
                            ldata<=32'bx;
                        end
                    endcase
                end
                else if(memwrite==1'b1)begin 
                    D_cache[index]<=B;
                    valid[index]<=1'b1;
                    dirty[index]<=1'b1;//至少修改了一次了 所以需变成脏数据
                    tag[index]<=aluout[31:9];
                end
                else ldata<=32'bx;
            end
        end
    end
    
endmodule