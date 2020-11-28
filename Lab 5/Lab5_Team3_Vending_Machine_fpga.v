module SampleDisplay(
	output wire [6:0] display,
	output wire [3:0] digit,
	output [3:0] LED,
	inout wire PS2_DATA,
	inout wire PS2_CLK,
	input wire rst,
	input wire clk,
	input five,
	input ten,
	input fifty,
	input cancel
	);
	
	wire rst_de;
	debounce de_rst(clk, rst, rst_de);
	
	wire clk_1s;
	divide_clock d1(clk, rst_de, clk_1s);
	
	wire de_5, op_5;
	debounce de_five(clk, five, de_5);
	OnePulse op_five(op_5, de_5, clk);
	
	wire de_10, op_10;
	debounce de_ten(clk, ten, de_10);
	OnePulse op_ten(op_10, de_10, clk);
	
	wire de_50, op_50;
	debounce de_fifty(clk, fifty, de_50);
	OnePulse op_fifty(op_50, de_50, clk);
	
	wire de_cxl, op_cxl;
	debounce de_cancel(clk, cancel, de_cxl);
	OnePulse op_cancel(op_cxl, de_cxl, clk);
	
	parameter [8:0] KEY_CODES [0:3] = {
		9'b0_0001_1100,	// a => 1C
		9'b0_0001_1011,	// s => 1B
		9'b0_0010_0011,	// d => 23
		9'b0_0010_1011	// f => 2B
	};
	
	reg [7:0] nums, next_nums;
	
	wire [511:0] key_down;
	wire [8:0] last_change;
	wire been_ready;
	
	SevenSegment seven_seg (
		.display(display),
		.digit(digit),
		.nums(nums),
		.rst(rst),
		.clk(clk)
	);
		
	KeyboardDecoder key_de (
		.key_down(key_down),
		.last_change(last_change),
		.key_valid(been_ready),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);
	
	reg [6:0] money, next_money;
	assign LED[3] = (money >= 7'd60);
	assign LED[2] = (money >= 7'd30);
	assign LED[1] = (money >= 7'd25);
	assign LED[0] = (money >= 7'd20);
	
	parameter IDLE = 3'd0;
	parameter coffee = 3'd1;
	parameter coke = 3'd2;
	parameter oolong = 3'd3;
	parameter water = 3'd4;
	parameter RETURN = 3'd5;
	
	reg [31:0] count, next_count;
	reg [2:0] state, next_state;
	
	always @ (posedge clk, posedge rst) begin
		if (rst) begin
			count <= 32'd0;
			state <= IDLE;
			money <= 7'b0;
			nums <= 8'b0;
		end
		else begin
			count <= next_count;
			state <= next_state;
			money <= next_money;
			nums <= next_nums;
		end
	end
	
	reg [5:0] right_most = (money[0] ? 6'd1 : 6'd0) +
						   (money[1] ? 6'd2 : 6'd0) + 
						   (money[2] ? 6'd4 : 6'd0) + 
						   (money[3] ? 6'd8 : 6'd0) + 
						   (money[4] ? 6'd6 : 6'd0) + 
						   (money[5] ? 6'd2 : 6'd0) + 
						   (money[6] ? 6'd4 : 6'd0) + 
						   (money[7] ? 6'd8 : 6'd0);
	always @ (*) begin
		
		case (state)
			IDLE: begin
				
				next_count = 32'd0;
				
				case ({op_5, op_10, op_50})
					3'b100: begin
						next_money = (money+7'd5 > 7'd99 ? 7'd99 : money+7'd5);
					end
					if (last_change == KEY_CODES[1] && money >= 7'd30) begin
							next_state = coke;
						end
						else begin
							if (last_change == KEY_CODES[2] && money >= 7'd25) begin
								next_state = oolong;
							end
							else begin
								if (last_change == KEY_CODES[3] && money >= 7'd20) begin
									next_state = water;
								end
								else begin
									next_state = IDLE;
								end
							end
						end
					end
				end
				else begin
					if (op_cxl) begin
						next_state = RETURN;
					end
					else begin
						next_state = IDLE;
					end
				end
			end
			
			coffee: begin
				next_state = RETURN;
				next_money = money - 7'd60;
				next_count = 32'd0;
			end
			
			coke: begin
				next_state = RETURN;
				next_money = money - 7'd30;
				next_count = 32'd0;
			end
			
			oolong: begin
				next_state = RETURN;
				next_money = money - 7'd25;
				next_count = 32'd0;
			end
			
			water: begin
				next_state = RETURN;
				next_money = money - 7'd20;
				next_count = 32'd0;
			end
			
			RETURN: begin
				next_money = (count == 32'd99999999 ? (money < 7'd5 ? 7'd0 : money - 7'd5) : money);
				next_state = (next_money == 7'd0 ? IDLE : RETURN);
				next_count = (count == 32'd99999999 ? 32'd0 : count + 32'd1);
			end
		endcase
		
		case (right_most)
			6'd0: next_nums[3:0] = 4'd0;
			6'd1: next_nums[3:0] = 4'd1;
			6'd2: next_nums[3:0] = 4'd2;
			6'd3: next_nums[3:0] = 4'd3;
			6'd4: next_nums[3:0] = 4'd4;
			6'd5: next_nums[3:0] = 4'd5;
			6'd6: next_nums[3:0] = 4'd6;
			6'd7: next_nums[3:0] = 4'd7;
			6'd8: next_nums[3:0] = 4'd8;
			6'd9: next_nums[3:0] = 4'd9;
			6'd10: next_nums[3:0] = 4'd0;
			6'd11: next_nums[3:0] = 4'd1;
			6'd12: next_nums[3:0] = 4'd2;
			6'd13: next_nums[3:0] = 4'd3;
			6'd14: next_nums[3:0] = 4'd4;
			6'd15: next_nums[3:0] = 4'd5;
			6'd16: next_nums[3:0] = 4'd6;
			6'd17: next_nums[3:0] = 4'd7;
			6'd18: next_nums[3:0] = 4'd8;
			6'd19: next_nums[3:0] = 4'd9;
			6'd20: next_nums[3:0] = 4'd0;
			6'd21: next_nums[3:0] = 4'd1;
			6'd22: next_nums[3:0] = 4'd2;
			6'd23: next_nums[3:0] = 4'd3;
			6'd24: next_nums[3:0] = 4'd4;
			6'd25: next_nums[3:0] = 4'd5;
			6'd26: next_nums[3:0] = 4'd6;
			6'd27: next_nums[3:0] = 4'd7;
			6'd28: next_nums[3:0] = 4'd8;
			6'd29: next_nums[3:0] = 4'd9;
			6'd30: next_nums[3:0] = 4'd0;
			6'd31: next_nums[3:0] = 4'd1;
			6'd32: next_nums[3:0] = 4'd2;
			6'd33: next_nums[3:0] = 4'd3;
			6'd34: next_nums[3:0] = 4'd4;
			6'd35: next_nums[3:0] = 4'd5;
		endcase
		// next_nums.
		
		case (money - next_nums[3:0])
			7'd0: next_nums[7:4] = 4'd0;
			7'd10: next_nums[7:4] = 4'd1;
			7'd20: next_nums[7:4] = 4'd2;
			7'd30: next_nums[7:4] = 4'd3;
			7'd40: next_nums[7:4] = 4'd4;
			7'd50: next_nums[7:4] = 4'd5;
			7'd60: next_nums[7:4] = 4'd6;
			7'd70: next_nums[7:4] = 4'd7;
			7'd80: next_nums[7:4] = 4'd8;
			7'd90: next_nums[7:4] = 4'd9;
		endcase
	end
	
endmodule

module debounce(clk, in, out);
	input clk, in;
	output out;
	
	reg [9:0] DFF;
	
	always @(posedge clk) begin
		DFF <= {in, DFF[9:1]};
	end
	
	assign out = &DFF;
	
endmodule

module OnePulse (
	output reg signal_single_pulse,
	input wire signal,
	input wire clock
	);
	
	reg signal_delay;

	always @(posedge clock) begin
		if (signal == 1'b1 & signal_delay == 1'b0)
		  signal_single_pulse <= 1'b1;
		else
		  signal_single_pulse <= 1'b0;

		signal_delay <= signal;
	end
endmodule

module divide_clock(clk, rst, out);
	input clk, rst;
	output out;
	
	reg [31:0] count;
	
	assign out = (count == 32'b0);
	
	always @(posedge clk) begin
		if (rst) begin
			count <= 32'b0;
		end
		else begin
			count = (count == 32'd99999999 ? 32'b0 : count + 32'b1);
		end
	end
endmodule

module KeyboardDecoder(
	output reg [511:0] key_down,
	output wire [8:0] last_change,
	output reg key_valid,
	inout wire PS2_DATA,
	inout wire PS2_CLK,
	input wire rst,
	input wire clk
    );
    
    parameter [1:0] INIT			= 2'b00;
    parameter [1:0] WAIT_FOR_SIGNAL = 2'b01;
    parameter [1:0] GET_SIGNAL_DOWN = 2'b10;
    parameter [1:0] WAIT_RELEASE    = 2'b11;
    
	parameter [7:0] IS_INIT			= 8'hAA;
    parameter [7:0] IS_EXTEND		= 8'hE0;
    parameter [7:0] IS_BREAK		= 8'hF0;
    
    reg [9:0] key;		// key = {been_extend, been_break, key_in}
    reg [1:0] state;
    reg been_ready, been_extend, been_break;
    
    wire [7:0] key_in;
    wire is_extend;
    wire is_break;
    wire valid;
    wire err;
    
    wire [511:0] key_decode = 1 << last_change;
    assign last_change = {key[9], key[7:0]};
    
    KeyboardCtrl_0 inst (
		.key_in(key_in),
		.is_extend(is_extend),
		.is_break(is_break),
		.valid(valid),
		.err(err),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);
	
	OnePulse op (
		.signal_single_pulse(pulse_been_ready),
		.signal(been_ready),
		.clock(clk)
	);
    
    always @ (posedge clk, posedge rst) begin
    	if (rst) begin
    		state <= INIT;
    		been_ready  <= 1'b0;
    		been_extend <= 1'b0;
    		been_break  <= 1'b0;
    		key <= 10'b0_0_0000_0000;
    	end else begin
    		state <= state;
			been_ready  <= been_ready;
			been_extend <= (is_extend) ? 1'b1 : been_extend;
			been_break  <= (is_break ) ? 1'b1 : been_break;
			key <= key;
    		case (state)
    			INIT : begin
    					if (key_in == IS_INIT) begin
    						state <= WAIT_FOR_SIGNAL;
    						been_ready  <= 1'b0;
							been_extend <= 1'b0;
							been_break  <= 1'b0;
							key <= 10'b0_0_0000_0000;
    					end else begin
    						state <= INIT;
    					end
    				end
    			WAIT_FOR_SIGNAL : begin
    					if (valid == 0) begin
    						state <= WAIT_FOR_SIGNAL;
    						been_ready <= 1'b0;
    					end else begin
    						state <= GET_SIGNAL_DOWN;
    					end
    				end
    			GET_SIGNAL_DOWN : begin
						state <= WAIT_RELEASE;
						key <= {been_extend, been_break, key_in};
						been_ready  <= 1'b1;
    				end
    			WAIT_RELEASE : begin
    					if (valid == 1) begin
    						state <= WAIT_RELEASE;
    					end else begin
    						state <= WAIT_FOR_SIGNAL;
    						been_extend <= 1'b0;
    						been_break  <= 1'b0;
    					end
    				end
    			default : begin
    					state <= INIT;
						been_ready  <= 1'b0;
						been_extend <= 1'b0;
						been_break  <= 1'b0;
						key <= 10'b0_0_0000_0000;
    				end
    		endcase
    	end
    end
    
    always @ (posedge clk, posedge rst) begin
    	if (rst) begin
    		key_valid <= 1'b0;
    		key_down <= 511'b0;
    	end else if (key_decode[last_change] && pulse_been_ready) begin
    		key_valid <= 1'b1;
    		if (key[8] == 0) begin
    			key_down <= key_down | key_decode;
    		end else begin
    			key_down <= key_down & (~key_decode);
    		end
    	end else begin
    		key_valid <= 1'b0;
			key_down <= key_down;
    	end
    end

endmodule

module SevenSegment(
	output reg [6:0] display,
	output reg [3:0] digit,
	input wire [7:0] nums,
	input wire rst,
	input wire clk
    );
    
    reg [15:0] clk_divider;
    reg [3:0] display_num;
    
    always @ (posedge clk, posedge rst) begin
    	if (rst) begin
    		clk_divider <= 15'b0;
    	end else begin
    		clk_divider <= clk_divider + 15'b1;
    	end
    end
    
    always @ (posedge clk_divider[15], posedge rst) begin
    	if (rst) begin
    		display_num <= 4'b0000;
    		digit <= 4'b1111;
    	end else begin
    		case (digit)
    			4'b1110 : begin
    					display_num <= nums[7:4];
    					digit <= 4'b1101;
    				end
    			4'b1101 : begin
						display_num <= nums[3:0];
						digit <= 4'b1110;
					end
    			default : begin
						display_num <= nums[3:0];
						digit <= 4'b1110;
					end				
    		endcase
    	end
    end
    
    always @ (*) begin
    	case (display_num)
    		0 : display = 7'b1000000;	//0000
			1 : display = 7'b1111001;   //0001                                                
			2 : display = 7'b0100100;   //0010                                                
			3 : display = 7'b0110000;   //0011                                             
			4 : display = 7'b0011001;   //0100                                               
			5 : display = 7'b0010010;   //0101                                               
			6 : display = 7'b0000010;   //0110
			7 : display = 7'b1111000;   //0111
			8 : display = 7'b0000000;   //1000
			9 : display = 7'b0010000;	//1001
			default : display = 7'b1111111;
    	endcase
    end
    
endmodule
