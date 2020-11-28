`timescale 1ns/1ps

module Traffic_Light_Controller (clk, rst_n, lr_has_car, hw_light, lr_light);
	input clk, rst_n;
	input lr_has_car;
	output [3-1:0] hw_light;
	output [3-1:0] lr_light;

	reg [2:0] state, next_state;
	reg [5:0] count, next_count;
	
	assign hw_light[0] = (state >= 3'd2);
	assign hw_light[1] = (state == 3'd1);
	assign hw_light[2] = (state == 3'd0);
	assign lr_light[0] = (state == 3'd3);
	assign lr_light[1] = (state == 3'd4);
	assign lr_light[2] = (state != 3'd3 && state != 3'd4);
	
	parameter IDLE = 3'b000;
	parameter S0 = 3'b001;
	parameter S1 = 3'b010;
	parameter S2 = 3'b011;
	parameter S3 = 3'b100;
	parameter S4 = 3'b101;
    
	always @(posedge clk) begin
		if (!rst_n) begin
			state <= IDLE;
			count <= 6'b0;
		end
		else begin
			state <= next_state;
			count <= next_count;
		end
	end

	always @(*) begin
		case (state)
			IDLE: begin
				next_state = (lr_has_car && count >= 6'd34 ? S0 : IDLE);
				next_count = (next_state == S0 ? 6'd0 : count + 6'd1);
			end
			
			S0: begin
				next_state = (count >= 6'd14 ? S1 : S0);
				next_count = (next_state == S1 ? 6'd0 : count + 6'd1);
			end
			
			S1: begin
				next_state = S2;
				next_count = 6'd0;
			end
			
			S2: begin
				next_state = (count >= 6'd34 ? S3 : S2);
				next_count = (next_state == S3 ? 6'd0 : count + 6'd1);
			end
			
			S3: begin
				next_state = (count >= 6'd14 ? S4 : S3);
				next_count = (next_state == S4 ? 6'd0 : count + 6'd1);
			end
			
			S4: begin
				next_state = IDLE;
				next_count = 6'd0;
			end
		endcase
	end

endmodule
