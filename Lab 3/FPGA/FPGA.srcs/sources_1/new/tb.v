`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2020 11:20:46 AM
// Design Name: 
// Module Name: tb
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


module tb();
    
    reg clk, rst, en, f;
    reg [3:0] max, min;
    wire [7:0] display;
    wire [3:0] decoder;
    
    Parameterized_Ping_Pong_Counter P1(clk, rst, en, f, max, min, display, decoder);
    
    always #1 clk = ~clk;
    
    initial begin
        clk = 0;
        en = 0;
        rst = 1;
        max = 15;
        min = 0;
        f = 0;
        
        @(negedge clk)  rst = 0;
        #10
        @(negedge clk)  rst = 1;
        #10
        en = 1;
        
        @(negedge clk)  rst = 0;
        #10
        @(negedge clk)  rst = 1;
        #15
        @(negedge clk) f = 1;
        #300
        @(negedge clk) f = 0;
        #300
        
        $finish;
    end
endmodule
