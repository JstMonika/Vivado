`timescale 1ns/1ps

module Comparator_t();
reg [3:0] a = 4'b0;
reg [3:0] b = 4'b0;
wire a_eq_b;
wire a_gt_b;
wire a_lt_b;

Comparator_4bits cmp(a, b, a_lt_b, a_gt_b, a_eq_b);

initial begin
	repeat (2**4) begin
		
		repeat (2**4)begin
			
			#1 b = b+1;
			
		end
		
		#1 a = a+1;
	end
	
	#1 $finish;
end
endmodule
