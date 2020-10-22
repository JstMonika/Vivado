`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2020 11:39:47 PM
// Design Name: 
// Module Name: Lab3_Team3_Parameterized_Ping_Pong_Counter_t
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


module Lab3_Team3_Parameterized_Ping_Pong_Counter_t();

reg clk;
reg enable, flip, rst_n;
always #0.5 clk = ~clk;

reg [3:0] max, min;
wire [3:0] out;
wire dir;

Parameterized_Ping_Pong_Counter P1(.clk(clk), .rst_n(rst_n), .enable(enable), .flip(flip), .max(max), .min(min), .direction(dir), .out(out));

initial begin
    clk = 0;
    enable = 1;
    flip = 0;
    rst_n = 0;
    max = 15;
    min = 0;
    
    @(negedge clk) rst_n = 0;
    @(negedge clk) rst_n = 1;
    
    #26
    flip = ~flip;
    
    #10
    flip = ~flip;
    
    #10
    @(negedge clk) rst_n = 0;
    #5
    @(negedge clk) rst_n = 1;
    
    #5
    enable = 0;
    #10
    enable = 1;
    #5
    $finish;
    // ....
end

endmodule
