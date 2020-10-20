`timescale 1ns/1ps

module Clock_Divider (clk, rst_n, sel, clk1_2, clk1_4, clk1_8, clk1_3, dclk);
input clk, rst_n;
input [2-1:0] sel;
output reg clk1_2;
output reg clk1_4;
output reg clk1_8;
output reg clk1_3;
output dclk;

assign dclk = (sel === 2'b00 ? clk1_3 :
               sel === 2'b01 ? clk1_2 :
               sel === 2'b10 ? clk1_4 : clk1_8);

reg [2:0] count2, count3, count4, count8;
wire [2:0] next2, next3, next4, next8;

always @(posedge clk) begin
    // 1/2
    if (count2 === 3'd1 && rst_n)
        clk1_2 <= 1'b1;
    else
        clk1_2 <= 1'b0;
        
    // 1/3
    if (count3 === 3'd2 && rst_n)
        clk1_3 <= 1'b1;
    else
        clk1_3 <= 1'b0;
    
    // 1/4
    if (count4 === 3'd3 && rst_n)
        clk1_4 <= 1'b1;
    else
        clk1_4 <= 1'b0;
    
    // 1/8
    if (count8 === 3'd7 && rst_n)
        clk1_8 <= 1'b1;
    else
        clk1_8 <= 1'b0;
end

always @(posedge clk) begin
    
    if (!rst_n) begin
        count2 <= 1;
        count3 <= 1;
        count4 <= 1;
        count8 <= 1;
    end
    
    else begin
       count2 <= (count2 == 1 ? 0 : count2 + 1);
       count3 <= (count3 == 2 ? 0 : count3 + 1);
       count4 <= (count4 == 3 ? 0 : count4 + 1);
       count8 <= (count8 == 7 ? 0 : count8 + 1);
    end
end

endmodule
