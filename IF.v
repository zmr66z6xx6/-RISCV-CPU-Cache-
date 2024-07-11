`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/04 17:32:15
// Design Name: 
// Module Name: IF
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


module IF(
    input [31:0]dest,lastpc,//跳转目标  输入指令  与跳转目标相对应的pc
    input error,jump,hazard,clk,rst,memhazard, //错误信号  跳转与否  冒险 时钟  重置
    output reg[31:0]pc, npc, instr //当前pc  下一条pc传给Imem 输出指令
);
    
    reg [31:0]Inst_ram[31:0];
    reg [31:0]buffer[31:0];
    reg [1:0]state[31:0];
    
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            /*buffer[0]<=32'd1;
            buffer[1]<=32'd2;
            buffer[2]<=32'd3;
            buffer[3]<=32'd4;
            buffer[4]<=32'd5;
            buffer[5]<=32'd6;
            buffer[6]<=32'd7;
            buffer[7]<=32'd8;
            buffer[8]<=32'd9;
            buffer[9]<=32'd10;
            buffer[10]<=32'd11;
            buffer[11]<=32'd12;
            buffer[12]<=32'd13;
            buffer[13]<=32'd14;
            buffer[14]<=32'd15;
            buffer[15]<=32'd16;
            buffer[16]<=32'd17;
            buffer[17]<=32'd18;
            buffer[18]<=32'd19;
            buffer[19]<=32'd20;
            buffer[20]<=32'd21;
            buffer[21]<=32'd22;
            Inst_ram[0]<=32'h01006093;        
            Inst_ram[1]<=32'h00209093;        
            Inst_ram[2]<=32'h0100e093;        
            Inst_ram[3]<=32'h01006113;        
            Inst_ram[4]<=32'h00211113;        
            Inst_ram[5]<=32'h00116113;        
            Inst_ram[6]<=32'h00006193;        
            Inst_ram[7]<=32'h001101b3;        
            Inst_ram[8]<=32'h00006193;        
            Inst_ram[9]<=32'h403081b3;        
            Inst_ram[10]<=32'h402181b3;        
            Inst_ram[11]<=32'h00218193;        
            Inst_ram[12]<=32'h00006193;        
            Inst_ram[13]<=32'h40018193;        
            Inst_ram[14]<=32'h00109093;        
            Inst_ram[15]<=32'h001101b3;        
            Inst_ram[16]<=32'h0ff06093;        
            Inst_ram[17]<=32'h01009093;        
            Inst_ram[18]<=32'h0000a133;        
            Inst_ram[19]<=32'h0000b133;        
            Inst_ram[20]<=32'h4000a113;        
            Inst_ram[21]<=32'h4000a113;*/
            /*buffer[0]<=32'd1; 
            buffer[1]<=32'd2;
            buffer[2]<=32'd3;
            buffer[3]<=32'd4;
            buffer[4]<=32'd5;
            buffer[5]<=32'd6;
            buffer[6]<=32'd7;
            buffer[7]<=32'd8;
            buffer[8]<=32'd9;
            buffer[9]<=32'd10;
            buffer[10]<=32'd11;
            Inst_ram[0]<=32'h00000293;        
            Inst_ram[1]<=32'h00000313;        
            Inst_ram[2]<=32'h00000393;        
            Inst_ram[3]<=32'h00a00e13;        
            Inst_ram[4]<=32'h00138393;        
            Inst_ram[5]<=32'h00530333;
            Inst_ram[6]<=32'h00128293;
            Inst_ram[7]<=32'hffc29ce3;
            Inst_ram[8]<=32'h00000293;
            Inst_ram[9]<=32'hffc396e3;
            Inst_ram[10]<=32'h00130313;*/
            
            /*buffer[0]<=32'd1;
            buffer[1]<=32'd2;
            buffer[2]<=32'd3;
            buffer[3]<=32'd4;
            buffer[4]<=32'd5;
            buffer[5]<=32'd6;
            buffer[6]<=32'd7;
            Inst_ram[0]<=32'h00000293;        
            Inst_ram[1]<=32'h00000313;        
            Inst_ram[2]<=32'h06500393;        
            Inst_ram[3]<=32'h00530333;
            Inst_ram[4]<=32'h00128293;
            Inst_ram[5]<=32'hfe729ce3;
            Inst_ram[6]<=32'h00130313;*/
            
            /*buffer[0]<=32'd1; 
            buffer[1]<=32'd2;
            buffer[2]<=32'd3;
            buffer[3]<=32'd4;
            buffer[4]<=32'd5;
            buffer[5]<=32'd6;
            buffer[6]<=32'd7;
            buffer[7]<=32'd8;
            Inst_ram[0]<=32'h001010b7;          
            Inst_ram[1]<=32'h1010e093;           
            Inst_ram[2]<=32'h1000e113;           
            Inst_ram[3]<=32'h0020e0b3;           
            Inst_ram[4]<=32'h0fe0f193;           
            Inst_ram[5]<=32'h0011f0b3;           
            Inst_ram[6]<=32'h3000c213;           
            Inst_ram[7]<=32'h001240b3;*/
            
            /*buffer[0]<=32'd1;//ld ans store
            buffer[1]<=32'd2;
            buffer[2]<=32'd3;
            buffer[3]<=32'd4;
            buffer[4]<=32'd5;
            buffer[5]<=32'd6;
            buffer[6]<=32'd7;
            buffer[7]<=32'd8;
            buffer[8]<=32'd9;
            buffer[9]<=32'd10;
            buffer[10]<=32'd11;
            buffer[11]<=32'd12;
            buffer[12]<=32'd13;
            buffer[13]<=32'd14;
            buffer[14]<=32'd15;
            buffer[15]<=32'd16;
            buffer[16]<=32'd17;
            buffer[17]<=32'd18;
            buffer[18]<=32'd19;
            buffer[19]<=32'd20;
            buffer[20]<=32'd21;
            buffer[21]<=32'd22; 
            buffer[22]<=32'd23;
            buffer[23]<=32'd24;
            Inst_ram[0]<=32'h0ff06193;
            Inst_ram[1]<=32'h003021a3;
            Inst_ram[2]<=32'h0081d193;
            Inst_ram[3]<=32'h00302123;
            Inst_ram[4]<=32'h0dd06193;        
            Inst_ram[5]<=32'h003020a3;        
            Inst_ram[6]<=32'h0081d193;        
            Inst_ram[7]<=32'h00302023;        
            Inst_ram[8]<=32'h00300083;        
            Inst_ram[9]<=32'h00204083;        
            Inst_ram[10]<=32'h00000013;        
            Inst_ram[11]<=32'h0bb06193;        
            Inst_ram[12]<=32'h00302223;        
            Inst_ram[13]<=32'h00405083;        
            Inst_ram[14]<=32'h00401083;        
            Inst_ram[15]<=32'h09906193;        
            Inst_ram[16]<=32'h00302323;        
            Inst_ram[17]<=32'h00601083;        
            Inst_ram[18]<=32'h00605083;        
            Inst_ram[19]<=32'h04506193;        
            Inst_ram[20]<=32'h01019193;        
            Inst_ram[21]<=32'h0671e193;        
            Inst_ram[22]<=32'h00302423;        
            Inst_ram[23]<=32'h00802083;*/ 
            
            /*buffer[0]<=32'd1;
            buffer[1]<=32'd2;
            buffer[2]<=32'd3;
            buffer[3]<=32'd4;
            buffer[4]<=32'd5;
            buffer[5]<=32'd6;
            buffer[6]<=32'd7;
            buffer[7]<=32'd8;
            buffer[8]<=32'd9;
            buffer[9]<=32'd10;
            buffer[10]<=32'd11;
            buffer[11]<=32'd12;
            Inst_ram[0]<=32'h00404137; 
            Inst_ram[1]<=32'h40416113;
            Inst_ram[2]<=32'h00706393;
            Inst_ram[3]<=32'h00506293;
            Inst_ram[4]<=32'h00806413;
            Inst_ram[5]<=32'h00811113;
            Inst_ram[6]<=32'h00711133;
            Inst_ram[7]<=32'h00815113;
            Inst_ram[8]<=32'h00515133;
            Inst_ram[9]<=32'h01311113;
            Inst_ram[10]<=32'h41015113;
            Inst_ram[11]<=32'h40815133;*/
            
            /*buffer[0]<=32'd1;//test1
            buffer[1]<=32'd2;
            buffer[2]<=32'd3;
            buffer[3]<=32'd4;
            buffer[4]<=32'd5;
            buffer[5]<=32'd6;
            buffer[6]<=32'd7;
            buffer[7]<=32'd8;
            buffer[8]<=32'd9;
            buffer[9]<=32'd10;
            buffer[10]<=32'd11;
            buffer[11]<=32'd12;
            buffer[12]<=32'd13;
            buffer[13]<=32'd14;
            buffer[14]<=32'd15;
            buffer[15]<=32'd16;
            buffer[16]<=32'd17;
            buffer[17]<=32'd18;
            buffer[18]<=32'd19;
            buffer[19]<=32'd20;
            buffer[20]<=32'd21;
            buffer[21]<=32'd22; 
            buffer[22]<=32'd23;
            buffer[23]<=32'd24;
            buffer[24]<=32'd25; 
            buffer[25]<=32'd26; 
            buffer[26]<=32'd27; 
            buffer[27]<=32'd28; 
            buffer[28]<=32'd29; 
            buffer[29]<=32'd30; 
            buffer[30]<=32'd31; 
            buffer[31]<=32'd32; 
            buffer[32]<=32'd33; 
            buffer[33]<=32'd34; 
            buffer[34]<=32'd35; 
            buffer[35]<=32'd36; 
            buffer[36]<=32'd37; 
            buffer[37]<=32'd38; 
            buffer[38]<=32'd39; 
            buffer[39]<=32'd40; 
            buffer[40]<=32'd41; 
            buffer[41]<=32'd42; 
            buffer[42]<=32'd43; 
            buffer[43]<=32'd44; 
            buffer[44]<=32'd45; 
            buffer[45]<=32'd46; 
            buffer[46]<=32'd47; 
            buffer[47]<=32'd48; 
            buffer[48]<=32'd49; 
            buffer[49]<=32'd50; 
            buffer[50]<=32'd51; 
            buffer[51]<=32'd52; 
            buffer[52]<=32'd53; 
            buffer[53]<=32'd54; 
            buffer[54]<=32'd55; 
            buffer[55]<=32'd56; 
            buffer[56]<=32'd57; 
            buffer[57]<=32'd58; 
            buffer[58]<=32'd59; 
            buffer[59]<=32'd60; 
            buffer[60]<=32'd61; 
            buffer[61]<=32'd62; 
            
            Inst_ram[0]<=32'h10004693;        
            Inst_ram[1]<=32'h00001137;        
            Inst_ram[2]<=32'h00004533;        
            Inst_ram[3]<=32'h000045b3;        
            Inst_ram[4]<=32'hfff68613;         
            Inst_ram[5]<=32'h00261613;         
            Inst_ram[6]<=32'h008000ef;         
            Inst_ram[7]<=32'h0000006f;
            
            Inst_ram[8]<=32'h0cc5da63;        
            Inst_ram[9]<=32'h0005e333;        
            Inst_ram[10]<=32'h000663b3;        
            Inst_ram[11]<=32'h006502b3;        
            Inst_ram[12]<=32'h0002a283;        

            Inst_ram[13]<=32'h04735263;        
            Inst_ram[14]<=32'h00750e33;        
            Inst_ram[15]<=32'h000e2e03;        
            Inst_ram[16]<=32'h005e4663;        
            Inst_ram[17]<=32'hffc38393;        
            Inst_ram[18]<=32'hfedff06f;        
            Inst_ram[19]<=32'h00650eb3;
            Inst_ram[20]<=32'h01cea023;
            Inst_ram[21]<=32'h02735263; 
            Inst_ram[22]<=32'h00650e33; 
            Inst_ram[23]<=32'h000e2e03; 
            Inst_ram[24]<=32'h01c2c663; 
            Inst_ram[25]<=32'h00430313; 
            Inst_ram[26]<=32'hfedff06f; 
            Inst_ram[27]<=32'h00750eb3; 
            Inst_ram[28]<=32'h01cea023; 
            Inst_ram[29]<=32'hfc7340e3; 
            Inst_ram[30]<=32'h00650eb3; 
            Inst_ram[31]<=32'h005ea023; 
            Inst_ram[32]<=32'hffc10113; 
            Inst_ram[33]<=32'h00112023; 
            Inst_ram[34]<=32'hffc10113; 
            Inst_ram[35]<=32'h00b12023; 
            Inst_ram[36]<=32'hffc10113; 
            Inst_ram[37]<=32'h00c12023; 
            Inst_ram[38]<=32'hffc10113; 
            Inst_ram[39]<=32'h00612023; 
            Inst_ram[40]<=32'hffc30613; 
            Inst_ram[41]<=32'hf7dff0ef; 
            Inst_ram[42]<=32'h00012303; 
            Inst_ram[43]<=32'h00410113; 
            Inst_ram[44]<=32'h00012603; 
            Inst_ram[45]<=32'h00410113; 
            Inst_ram[46]<=32'h00012583; 
            Inst_ram[47]<=32'hffc10113; 
            Inst_ram[48]<=32'h00c12023; 
            Inst_ram[49]<=32'hffc10113; 
            Inst_ram[50]<=32'h00612023; 
            Inst_ram[51]<=32'h00430593; 
            Inst_ram[52]<=32'hf51ff0ef; 
            Inst_ram[53]<=32'h00012303; 
            Inst_ram[54]<=32'h00410113; 
            Inst_ram[55]<=32'h00012603; 
            Inst_ram[56]<=32'h00410113; 
            Inst_ram[57]<=32'h00012583; 
            Inst_ram[58]<=32'h00410113; 
            Inst_ram[59]<=32'h00012083; 
            Inst_ram[60]<=32'h00410113; 
            Inst_ram[61]<=32'h00008067;*/
            
            /*buffer[0]<=32'd1;//test2
            buffer[1]<=32'd2;
            buffer[2]<=32'd3;
            buffer[3]<=32'd4;
            buffer[4]<=32'd5;
            buffer[5]<=32'd6;
            buffer[6]<=32'd7;
            buffer[7]<=32'd8;
            buffer[8]<=32'd9;
            buffer[9]<=32'd10;
            buffer[10]<=32'd11;
            buffer[11]<=32'd12;
            buffer[12]<=32'd13;
            buffer[13]<=32'd14;
            buffer[14]<=32'd15;
            buffer[15]<=32'd16;
            buffer[16]<=32'd17;
            buffer[17]<=32'd18;
            buffer[18]<=32'd19;
            buffer[19]<=32'd20;
            buffer[20]<=32'd21;
            buffer[21]<=32'd22; 
            buffer[22]<=32'd23;
            buffer[23]<=32'd24;
            buffer[24]<=32'd25; 
            buffer[25]<=32'd26; 
            buffer[26]<=32'd27; 
            buffer[27]<=32'd28; 
            buffer[28]<=32'd29; 
            buffer[29]<=32'd30; 
            buffer[30]<=32'd31; 
            
            Inst_ram[0]<=32'h00404713;
            Inst_ram[1]<=32'h00404693;
            Inst_ram[2]<=32'h00e696b3;
            Inst_ram[3]<=32'h00004633;
            Inst_ram[4]<=32'h00e69533;
            Inst_ram[5]<=32'h00a505b3;
            Inst_ram[6]<=32'h000042b3;
            Inst_ram[7]<=32'h00004333;
            Inst_ram[8]<=32'h00004e33;
            Inst_ram[9]<=32'h000043b3;
            Inst_ram[10]<=32'h00e29eb3;
            Inst_ram[11]<=32'h007e8eb3;
            Inst_ram[12]<=32'h00ae8eb3;
            Inst_ram[13]<=32'h000eae83;
            Inst_ram[14]<=32'h00e39f33;
            Inst_ram[15]<=32'h006f0f33;
            Inst_ram[16]<=32'h00bf0f33;
            Inst_ram[17]<=32'h000f2f03;
            Inst_ram[18]<=32'h01eefeb3;
            Inst_ram[19]<=32'h01de0e33;
            Inst_ram[20]<=32'h00438393;
            Inst_ram[21]<=32'hfcd3cae3;
            Inst_ram[22]<=32'h00e29eb3;
            Inst_ram[23]<=32'h006e8eb3;
            Inst_ram[24]<=32'h00ce8eb3;
            Inst_ram[25]<=32'h01cea023;
            Inst_ram[26]<=32'h00430313;
            Inst_ram[27]<=32'hfad34ae3;
            Inst_ram[28]<=32'h00428293;
            Inst_ram[29]<=32'hfad2c4e3;
            Inst_ram[30]<=32'h0000006f;*/
            
            buffer[0]<=32'd1;
            buffer[1]<=32'd2;
            buffer[2]<=32'd3;
            buffer[3]<=32'd4;
            buffer[4]<=32'd5;
            buffer[5]<=32'd6;
            buffer[6]<=32'd7;
            buffer[7]<=32'd8;
            buffer[8]<=32'd9;
            buffer[9]<=32'd10;
            buffer[10]<=32'd11;
            buffer[11]<=32'd12;
            buffer[12]<=32'd13;
            buffer[13]<=32'd14;
            buffer[14]<=32'd15;
            buffer[15]<=32'd16;
            buffer[16]<=32'd17;
            buffer[17]<=32'd18;            
                        

            Inst_ram[0]<=32'b00000000000000000000100110110011;
            Inst_ram[1]<=32'b00000010000000000000100110010011;
            Inst_ram[2]<=32'b00000000000010011010100100000011;
            Inst_ram[3]<=32'b00000001001010010000100100110011;
            Inst_ram[4]<=32'b00000001111010010000100100010011;
            Inst_ram[5]<=32'b00000010000000000010101000000011;
            Inst_ram[6]<=32'b00000000000010010000101000110011;
            Inst_ram[7]<=32'b00000001010010100010000100100011;
            Inst_ram[8]<=32'b00000010000000000010101010000011;
            Inst_ram[9]<=32'b00000001010010101000101010110011;
            Inst_ram[10]<=32'b00011110010010101000101010010011;
            Inst_ram[11]<=32'b00001110000110010000100100010011;
            Inst_ram[12]<=32'b00000001001010101010000000100011;
            Inst_ram[13]<=32'b00000000000010101000101000000011;
            Inst_ram[14]<=32'b00000000000010100000101000110011;
            Inst_ram[15]<=32'b00000010000000000010101000000011;
            Inst_ram[16]<=32'b00000010000000000010101000000011;
            Inst_ram[17]<=32'b00000000000010101010101010000011;
            // 09b30000

            pc<=32'b0;
            npc<=32'b0;
            instr<=32'bx;
        end
        else if(memhazard==1'b1)begin
            pc<=pc;
            npc<=npc;
            instr<=instr;
        end
        else begin
            if(error==1'b1)begin//因为我们的一旦error那么即使有Hazard也会被刷掉，优先级error>hazard
                pc<=dest;
                npc<=buffer[dest];               //更新正确的pc的同时也要更新预测的目标地址
                instr<=Inst_ram[dest];
                if(jump==1'b1)begin//实际跳转了，预测没跳转
                    if(state[lastpc]==2'b01)begin
                        state[lastpc]<=2'b10;
                        buffer[lastpc]<=dest;
                    end
                    else begin
                        state[lastpc]<=2'b01;
                    end
                end
                else begin //实际顺序执行，预测跳转
                    if(state[lastpc]==2'b10)begin
                        state[lastpc]<=2'b01;
                        buffer[lastpc]<=dest;
                    end
                    else begin
                        state[lastpc]<=2'b10;
                    end
                end
            end
            else begin
                if(hazard==1'b1)begin
                    pc<=pc;
                    npc<=npc;
                    instr<=instr;
                end
                else begin
                    pc<=npc;
                    npc<=buffer[npc];
                    instr<=Inst_ram[npc];
                end
                //预测成功仍然需要对状态机进行更新 变成强跳转 或者 强不跳转
                if(jump==1'b1)begin
                    if(state[lastpc]==2'b10)state[lastpc]<=2'b11;
                end
                else if(jump==1'b0)begin
                    if(state[lastpc]==2'b01)state[lastpc]<=2'b00;
                end
            end
        end
    end

endmodule
