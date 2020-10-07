`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/02/2020 10:07:44 PM
// Design Name: 
// Module Name: Lab2_Team3_Binary_to_Grey_t
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


module Lab2_Team3_Binary_to_Grey_t();
    
    reg [3:0] din;
    wire [3:0] dout;
    
    Binary_to_Grey btg(.din(din), .dout(dout));
    
    initial begin
       din = 4'b0;
       
       repeat (2 ** 4) begin
           #1 din = din + 4'b1;
       end
       
       #1 $finish;
    end
endmodule
