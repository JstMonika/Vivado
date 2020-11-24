`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2020 01:51:59 PM
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

    reg clk, rst_n, in;
    wire [2:0] hw, lr;
    
    Traffic_Light_Controller T1(clk, rst_n, in, hw, lr);
    
    always #1 clk = ~clk;
    
    initial begin
        clk = 0;
        rst_n = 0;
        
        #5
        @(negedge clk) rst_n = 1;
        
        #30
        @(negedge clk) in = 1;
        
        @(negedge clk) in = 0;
        
        #50
        @(negedge clk) in = 1;
        
        @(negedge clk) in = 0;
        
        #400
        $finish;
    end
endmodule
