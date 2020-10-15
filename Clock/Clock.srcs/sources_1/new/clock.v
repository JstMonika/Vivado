`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2020 02:46:04 PM
// Design Name: 
// Module Name: clock
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


module clock(clk, digit, dot, );
    input clk;
    
    wire clk_240Hz;
    
    reg [3:0] w;
    
    wire [3:0] next = {w[2:0], w[3]};
    
    reg a;
    wire next, en;
    always @(posedge clk) begin
        if (en)
            a <= next;
        else
            a <= a;
    end
    
endmodule
