`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2020 01:57:48 AM
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

    reg clk, rst_n;
    reg in;
    wire [1:0] out;
    
    Sliding_Window_Detector S1(clk, rst_n, in, out[1], out[0]);
    
    always #1 clk = ~clk;
    
    initial begin
        clk = 0;
        rst_n = 0;
        in = 0;
        
        #5
        @(negedge clk) rst_n = 1;
        
        @(negedge clk) in = 1;
        @(negedge clk) in = 1;
        @(negedge clk) in = 0;
        @(negedge clk) in = 1;
        @(negedge clk) in = 1;
        @(negedge clk) in = 0;
        @(negedge clk) in = 1;
        @(negedge clk) in = 0;
        @(negedge clk) in = 1;
        @(negedge clk) in = 1;
        @(negedge clk) in = 0;
        @(negedge clk) in = 1;
        @(negedge clk) in = 1;
        @(negedge clk) in = 1;
        @(negedge clk) in = 1;
        @(negedge clk) in = 0;
        @(negedge clk) in = 1;
        @(negedge clk) in = 0;
        @(negedge clk) in = 1;
        @(negedge clk) in = 0;
        @(negedge clk) in = 1;
        
        $finish;
    end
endmodule
