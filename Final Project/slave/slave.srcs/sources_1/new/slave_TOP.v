`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/10/2021 09:05:23 PM
// Design Name: 
// Module Name: slave_TOP
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


module slave_TOP(
    input [7:0] in_display,
    input [3:0] in_digit,
    output [7:0] display,
    output [3:0] digit
    );
    
    assign display = in_display;
    assign digit = in_digit;
    
endmodule
