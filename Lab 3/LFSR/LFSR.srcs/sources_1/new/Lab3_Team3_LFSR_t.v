`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2020 01:17:20 PM
// Design Name: 
// Module Name: Lab3_Team3_LFSR_t
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


module Lab3_Team3_LFSR_t();

reg clk = 0;
reg rst_n = 0;
wire out;

LFSR f1(.clk(clk), .rst_n(rst_n), .out(out)); 

always #5 clk = ~clk;

initial begin
    rst_n = 0;
    #10
    rst_n = 1;
    
    repeat (2 ** 5) begin
        #5
        ;
    end    
end

endmodule