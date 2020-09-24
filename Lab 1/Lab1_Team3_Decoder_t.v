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
reg [3:0] din = 4'b0;
wire [15:0] dout;

Decoder d1( .din(din), .dout(dout));

initial begin
	repeat (2**4) begin
		
		#1 din = din + 1'b1;
		
	end
	
	#1 $finish;
end
endmodule
