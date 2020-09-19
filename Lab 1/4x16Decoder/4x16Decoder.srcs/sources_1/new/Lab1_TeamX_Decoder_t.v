`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2020 05:01:49 PM
// Design Name: 
// Module Name: Lab1_TeamX_Decoder_t
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

module Decoder_t;
reg din = 4'b0;
reg dout = 16'b0;

Decoder d1( .din(din), .dout(dout));

initial begin
	repeat (2**4) begin
	  $display("Now din = %d and dout = %d",din,dout);
	  #1 din = din + 1'b1;
	end
	#1 $finish;
end
endmodule
