`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/01/2021 04:26:24 PM
// Design Name: 
// Module Name: SevenSegment
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


module SevenSegment(
	output reg [7:0] display,
	output reg [3:0] digit,		
	
	input wire [31:0] input_nums,		// input Segment
	
	input wire rst,
	input wire clk
    );
    
	wire [31:0] nums = ~input_nums;
	
    reg [15:0] clk_divider;
    
    always @ (posedge clk, posedge rst) begin
    	if (rst) begin
    		clk_divider <= 15'b0;
    	end else begin
    		clk_divider <= clk_divider + 15'b1;
    	end
    end
    
    always @ (posedge clk_divider[15], posedge rst) begin
    	if (rst) begin
    		display <= 8'b0;
    		digit <= 4'b1111;
    	end else begin
    		case (digit)
    			4'b1110 : begin
    					display <= nums[15:8];
    					digit <= 4'b1101;
    				end
    			4'b1101 : begin
						display <= nums[23:16];
						digit <= 4'b1011;
					end
    			4'b1011 : begin
						display <= nums[31:24];
						digit <= 4'b0111;
					end
    			4'b0111 : begin
						display <= nums[7:0];
						digit <= 4'b1110;
					end
    			default : begin
						display <= nums[7:0];
						digit <= 4'b1110;
					end				
    		endcase
    	end
    end
    
endmodule
