`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2020 12:55:26 AM
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

reg clk, rst_n, trigger;
wire [7:0] display;
wire [3:0] led;

Lab4_Team3_Stopwatch_fpga M1(clk, rst_n, trigger, display, led);

always #1 clk = ~clk;
initial begin
    clk = 0;
    trigger = 0;
    rst_n = 0;
    
    #65
    @(negedge clk)
    rst_n = 1;
    #150
    @(negedge clk)
    rst_n = 0;
    #60
    
    @(negedge clk)
    trigger = 1;
    #150
    @(negedge clk)
    trigger = 0;
    #500
    
    @(negedge clk)
    rst_n = 1;
    #600
    @(negedge clk)
    rst_n = 0;
    
    #500;
    $finish;
end

endmodule
