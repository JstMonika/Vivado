`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/09/2020 03:33:19 PM
// Design Name: 
// Module Name: Lab4_Team3_Greatest_Common_Divisor_t
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


module Lab4_Team3_Greatest_Common_Divisor_t();
    reg clk, rst_n, start;
    reg [15:0] a, b;
    wire Complete;
    wire [15:0] out;
    
    Greatest_Common_Divisor M1(.clk(clk), .rst_n(rst_n), .Begin(start), .a(a), .b(b), .Complete(Complete), .gcd(out));
    
    always #1 clk = ~clk;
    
    initial begin
        clk = 0;
        rst_n = 0;
        
        @(posedge clk)
        
        #2
        
        @(negedge clk)
        rst_n = 1;
        a = 6;
        b = 16;
        start = 1;
        
        @(negedge clk)
        start = 0;
        
        @(posedge Complete)
        @(negedge Complete)
        @(negedge clk)
        a = 32;
        b = 81;
        start = 1;
        
        @(negedge clk)
        start = 0;
        
        @(posedge Complete)
        @(negedge Complete)
        
        #5
        $finish;
    end
endmodule
