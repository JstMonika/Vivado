`timescale 1ns/1ps

module Comparator_t;
reg a = 4'b0;
reg b = 4'b0;
wire a_eq_b;
wire a_gt_b;
wire a_lt_b;

Comparator_4bits cmp(a, b, a_lt_b, a_gt_b, a_eq_b);

initial begin
	repeat (2**4) begin
		b = 0;
		repeat (2**4)begin
			$display("Now a = %d, b = %d",a,b);
			if(a<b && a_lt_b && !a_eq_b && !a_gt_b)begin
				$display("correct");
			end
			if(a==b && !a_lt_b && a_eq_b && !a_gt_b)begin
				$display("correct");
			end
			if(a>b && !a_lt_b && !a_eq_b && a_gt_b)begin
				$display("correct");
			end
			#1 b = b+1;
		end
		#1 a = a+1;
	end
	#1 $finish;
end
endmodule
