`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2020 11:05:49 PM
// Design Name: 
// Module Name: Lab5_TeamX_Musical_Scale_fpga
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


module Lab5_TeamX_Musical_Scale_fpga(
    input clk,
    
    // keyboard input
    inout PS2_DATA,
    inout PS2_CLK,
    
    // audio output
    output pmod_1,
    output pmod_2,
    output pmod_4
);
    
    reg up;
    
    parameter [8:0] KEY_CODES [0:3] = {
        9'b0_0101_1010, // enter -> 5A
        9'b0_0111_0000, // right_0 -> 70
        9'b0_0110_1001, // right_1 -> 69
        9'b0_0111_0010 // right_2 -> 72
    };
    
    assign pmod_2 = 1'd1;
    assign pmod_4 = 1'd1;
    
    // keyboard.
    wire [511:0] key_down;
    wire [8:0] last_change;
    wire ready;
    
    wire reset;
    assign reset = key_down[KEY_CODES[0]];
   
    reg [31:0] BEAT_FREQ;    // one beat
    parameter DUTY_BEST = 10'd512;
    
    wire [31:0] tone_freq;
    wire beat;
    
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            BEAT_FREQ <= 32'd2;
            up <= 1'b1;
        end
        else begin
            if (ready && key_down[last_change] == 1'b1) begin
                if (last_change == KEY_CODES[3])
                    BEAT_FREQ <= 32'd3 - BEAT_FREQ;
                else
                    BEAT_FREQ <= BEAT_FREQ;
            end
            else
                BEAT_FREQ <= BEAT_FREQ;
            
            if (ready && key_down[last_change] == 1'b1) begin
                if (last_change == KEY_CODES[2])
                    up <= 1'b0;
                else if (last_change == KEY_CODES[1])
                    up <= 1'b1;
                else
                    up <= up;
            end
            else begin
                up <= up;
            end
                                                                                                                                                                                                                                                                                                                                                               end
    end
    
    // n_up.
    // n_BEAT_FREQ.
    
    //keyboard
    KeyboardDecoder key_de( .clk(clk),
                            .rst(reset),
                            .PS2_DATA(PS2_DATA),
                            .PS2_CLK(PS2_CLK),
                            .key_valid(ready),
                            .last_change(last_change),
                            .key_down(key_down)
    );
    
    PWM_gen beatSpeed( .clk(clk),
                       .reset(reset),
                       .freq(BEAT_FREQ), ㄆ
                       .duty(DUTY_BEST),
                       .PWM(beat)
    );
    
    Music next_tone( .clk(clk),
                     .trigger(beat),
                     .reset(reset),
                     .dir(up),
                     .tone(tone_freq)
    );
    
    PWM_gen toneFreq( .clk(clk),
                      .reset(reset),
                      .freq(tone_freq),
                      .duty(DUTY_BEST),
                      .PWM(pmod_1)
    );
    
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

module PWM_gen (
    input wire clk,
    input wire reset,
	input [31:0] freq,
    input [9:0] duty,
    output reg PWM
    );

    wire [31:0] count_max = 100_000_000 / freq;
    wire [31:0] count_duty = count_max * duty / 1024;
    reg [31:0] count;
        
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            count <= 0;
            PWM <= 0;
        end else if (count < count_max) begin
            count <= count + 1;
            if(count < count_duty)
                PWM <= 1;
            else
                PWM <= 0;
        end else begin
            count <= 0;
            PWM <= 0;
        end
    end

endmodule

`define NM1 32'd262 //C_freq
`define NM2 32'd294 //D_freq
`define NM3 32'd330 //E_freq
`define NM4 32'd349 //F_freq
`define NM5 32'd392 //G_freq
`define NM6 32'd440 //A_freq
`define NM7 32'd494 //B_freq
`define NM0 32'd20000 //slience (over freq.)

module Music (
    input clk,
    input trigger,
    input reset,
    input dir,
	output reg [31:0] tone
    );
    
    reg prev;
    reg [4:0] note, n_note;
    
    always @(posedge clk, posedge reset) begin
        prev <= trigger;
        
        if (reset) begin
            note <= 5'd0;
        end
        else begin
            if (trigger && !prev) begin
                note <= n_note;
            end
            else begin
                note <= note;
            end
        end
    end
    
    always @(*) begin
        if (dir && (note != 5'd29))
            n_note = note + 5'd1;
        else begin
            if (!dir && note != 5'd1) begin
                n_note = note - 5'd1;
            end
            else begin
                n_note = note;
            end
        end               
        
        case (note)		// 1 beat
            8'd0 : tone = `NM1;
            8'd1 : tone = `NM1;
            8'd2 : tone = `NM2;
            8'd3 : tone = `NM3;
            8'd4 : tone = `NM4;
            8'd5 : tone = `NM5;
            8'd6 : tone = `NM6;
            8'd7 : tone = `NM7;
            8'd8 : tone = `NM1 << 1;
            8'd9 : tone = `NM2 << 1;
            8'd10 : tone = `NM3 << 1;
            8'd11 : tone = `NM4 << 1;
            8'd12 : tone = `NM5 << 1;
            8'd13 : tone = `NM6 << 1;
            8'd14 : tone = `NM7 << 1;
            8'd15 : tone = `NM1 << 2;
            8'd16 : tone = `NM2 << 2;
            8'd17 : tone = `NM3 << 2;
            8'd18 : tone = `NM4 << 2;
            8'd19 : tone = `NM5 << 2;
            8'd20 : tone = `NM6 << 2;
            8'd21 : tone = `NM7 << 2;
            8'd22 : tone = `NM1 << 3;
            8'd23 : tone = `NM2 << 3;
            8'd24 : tone = `NM3 << 3;
            8'd25 : tone = `NM4 << 3;
            8'd26 : tone = `NM5 << 3;
            8'd27 : tone = `NM6 << 3;
            8'd28 : tone = `NM7 << 3;
            8'd29 : tone = `NM1 << 4;
           
            default : tone = `NM0;
        endcase
    end

endmodule
