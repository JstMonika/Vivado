`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/01/2021 05:12:46 PM
// Design Name: 
// Module Name: Game_TOP
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

module Game_TOP(
    input clk, // W5
    input rst, // T18
    input [5:0] hit_signal, // pins
    input BTNC, // U18
    input BTNL, // W19
    input BTNR, // T17
    input BTND, // U17
    input [6:0] switch,
    
    output [7:0] display,
    output [3:0] digit,
    output [7:0] remote_display,
    output [3:0] remote_digit,
    output [15:0] LED,
    
    output [1:0] eng_en,
    output [1:0] eng_l,
    output [1:0] eng_r
    
);
    wire de_rst, op_rst;
    debounce drst(clk, rst, de_rst);
    onepulse orst(clk, de_rst, op_rst);
    
    wire [5:0] de_hit_signal, op_hit_signal;
    debounce dhs [5:0] (clk, hit_signal, de_hit_signal);
    onepulse ohs [5:0] (clk, de_hit_signal, op_hit_signal);
    
    wire de_BTNC, op_BTNC;
    debounce dbtnc(clk, BTNC, de_BTNC);
    onepulse obtnc(clk, de_BTNC, op_BTNC);
    
    wire de_BTNL, op_BTNL;
    debounce dbtnl(clk, BTNL, de_BTNL);
    onepulse obtnl(clk, de_BTNL, op_BTNL);
    
    wire de_BTNR, op_BTNR;
    debounce dbtnr(clk, BTNR, de_BTNR);
    onepulse obtnr(clk, de_BTNR, op_BTNR);
    
    wire de_BTND, op_BTND;
    debounce dbtnd(clk, BTND, de_BTND);
    onepulse obtnd(clk, de_BTND, op_BTND);
    
    parameter IDLE = 4'd0;
    parameter waiting_hit_signal = 4'd1;
    parameter waiting_reset = 4'd2;
    parameter clear = 4'd3;
    parameter DONE = 4'd4;
    // parameter 
    
    reg [3:0] game_stage, next_game_stage;    // 1st ~ 9th.
    reg [3:0] select_stage, next_select_stage;
    reg [3:0] finish_stage, next_finish_stage;
    reg [3:0] top_point_l, next_top_point_l;
    reg [3:0] top_point_r, next_top_point_r;
    reg [3:0] bottom_point_l, next_bottom_point_l;
    reg [3:0] bottom_point_r, next_bottom_point_r;
    reg is_top, next_is_top;
    
    
    reg hit;
    parameter STRIKE = 3'd0;
    parameter B1 = 3'd1;
    parameter B2 = 3'd2;
    parameter B3 = 3'd3;
    parameter OUT = 3'd4;
    parameter HR = 3'd5;
    parameter VOID = 3'd6;
    reg [2:0] result, next_result; // strike, 1B, 2B, 3B, OUT, HR
    reg record_hit_finish;
    
    reg [1:0] strike, next_strike;
    reg [1:0] out, next_out;
    reg [2:0] base, next_base;
    
    reg s_count, next_s_count;
    wire finish, half_finish;
    wire in_clear, out_clear, half_out_clear;
    
    reg [3:0] state, next_state;
    
    reg [31:0] data;
    wire [31:0] next_data;
    
    reg [31:0] remote_data;
    reg [31:0] remote_next_data;
    reg [7:0] seg[3:0];
    
    wire score_infor;
    remote_display_counter RDC1(.clk(clk), .rst(op_rst), .out(score_infor));
    
    SevenSegment S1(.display(display), .digit(digit), .input_nums(data), .clk(clk), .rst(op_rst));
    SevenSegment S2(.display(remote_display), .digit(remote_digit), .input_nums(remote_data), .clk(clk), .rst(op_rst));
    
    assign next_data = {seg[3], seg[2], seg[1], seg[0]};
    
    reg [2:0] hit_result;
    
    always @(posedge clk) begin
        if (op_rst) begin
            state <= IDLE;
            game_stage <= 4'd0;
            select_stage <= 4'd1;
            finish_stage <= 4'd3;
            strike <= 2'd0;
            out <= 2'd0;
            base <= 3'd0;
            top_point_l <= 4'd0;
            top_point_r <= 4'd0;
            bottom_point_l <= 4'd0;
            bottom_point_r <= 4'd0;
            hit_result <= 3'd0;
            s_count <= 1'd0;
            result <= VOID;
            is_top <= 1'd0;
            remote_data <= 32'd0;
            data <= 32'd0;
        end
        else begin
            state <= next_state;
            game_stage = next_game_stage;
            select_stage <= next_select_stage;
            finish_stage <= next_finish_stage;
            strike <= next_strike;
            out <= next_out;
            base <= next_base;
            top_point_l <= next_top_point_l;
            top_point_r <= next_top_point_r;
            bottom_point_l <= next_bottom_point_l;
            bottom_point_r <= next_bottom_point_r;
            hit_result <= hit_result + 3'd1;
            s_count <= next_s_count;
            result <= next_result;
            is_top <= next_is_top;
            remote_data <= remote_next_data;
            data <= next_data;
        end
    end
    
    wire [7:0] gs_num;
    convert_num c1(.in(game_stage), .point(~is_top), .out(gs_num));    // 4, 1, 8 bits
    
    wire [7:0] ss_num;
    convert_num c2(.in(select_stage), .point(1'b0), .out(ss_num));
    
    
    wire [7:0] top_lnum, top_rnum;
    convert_num c3(.in(top_point_l), .point(1'b0), .out(top_lnum));
    convert_num c4(.in(top_point_r), .point(is_top), .out(top_rnum));
    
    wire [7:0] bottom_lnum, bottom_rnum;
    convert_num c5(.in(bottom_point_l), .point(1'b0), .out(bottom_lnum));
    convert_num c6(.in(bottom_point_r), .point(~is_top), .out(bottom_rnum));
    
    assign in_clear = (state == clear);
    
    always @(*) begin
        
        case ({op_BTNL, op_BTNR})
            2'b10: begin
                if (select_stage == 4'd1)
                    next_select_stage = 4'd9;
                else
                    next_select_stage = select_stage - 4'd1;
            end
            
            2'b01: begin
                if (select_stage == 4'd9)
                    next_select_stage = 4'd1;
                else
                    next_select_stage = select_stage + 4'd1;
            end
            
            default: next_select_stage = select_stage;
        endcase
        
        next_state = state;
        next_game_stage = game_stage;
        next_is_top = is_top;
        next_finish_stage = finish_stage;
        next_strike = strike;
        next_out = out;
        next_base = base;
        next_top_point_l = top_point_l;
        next_top_point_r = top_point_r;
        next_bottom_point_l = bottom_point_l;
        next_bottom_point_r = bottom_point_r;
        next_s_count = 1'b0;
        hit = |op_hit_signal;
        next_result = result;
        record_hit_finish = (result != VOID);
        
        if (score_infor) begin
            remote_next_data = {top_lnum, top_rnum, bottom_lnum, bottom_rnum};
        end
        else begin
            remote_next_data = {strike != 2'b0, 2'b0, out != 2'b0, 2'b0, base[2], 1'b0,
                                strike[1], 2'b0, out[1], 2'b0, base[1], 1'b0,
                                6'b0, base[0], 1'b0,
                                gs_num};
        end
        
        seg[3] = 8'b0;
        seg[2] = 8'b0;
        seg[1] = 8'b0;
        seg[0] = 8'b0;
        
        case (state)
            IDLE: begin
                next_state = (op_BTNC ? waiting_reset : IDLE);
                next_finish_stage = (op_BTNC ? select_stage : finish_stage);
                
                next_strike = 2'b0;
                next_out = 2'b0;
                next_base = 3'b0;
                next_is_top = (op_BTNC ? 1'b1 : 1'b0);
                next_game_stage = 4'd1;
                
                next_top_point_l = 4'b0;
                next_top_point_r = 4'b0;
                next_bottom_point_l = 4'b0;
                next_bottom_point_r = 4'b0;
                
                seg[3] = 8'b00010000;
                seg[2] = 8'b00010000;
                seg[1] = 8'b11101110;
                seg[0] = ss_num;
                
                remote_next_data = 32'b0111_0110_1101_0000_1101_0000_1101_0000;
            end
            
            waiting_hit_signal: begin
                next_state = (record_hit_finish && finish) ? waiting_reset : waiting_hit_signal;
                next_s_count = finish ? 1'b0 : ((result != VOID) ? 1'b1 : s_count);
                
                if (record_hit_finish && finish) begin
                    case (result)
                        STRIKE: begin
                            if (strike == 2'd2) begin
                                next_out = out + 2'b1;
                                next_strike = 2'b0;
                            end
                            else begin
                                next_out = out;
                                next_strike = strike + 2'b1;
                            end
                        end
                        
                        B1: begin
                            next_strike = 2'b0;
                            next_base = {base[1:0], 1'b1};
                            
                            if (is_top) begin
                                
                                if (top_point_r + base[2] > 4'd9) begin
                                    next_top_point_l = (top_point_l == 4'd9 ? 4'd0 : top_point_l + 4'd1);
                                    next_top_point_r = top_point_r + base[2] - 4'd10;
                                end
                                else begin
                                    next_top_point_r = top_point_r + base[2];
                                end
                                
                            end
                            else begin
                                
                                if (bottom_point_r + base[2] > 4'd9) begin
                                    next_bottom_point_l = (bottom_point_l == 4'd9 ? 4'd0 : bottom_point_l + 4'd1);
                                    next_bottom_point_r = bottom_point_r + base[2] - 4'd10;
                                end
                                else begin
                                    next_bottom_point_r = bottom_point_r + base[2];
                                end
                            end
                            
                        end
                        
                        B2: begin
                            next_strike = 2'b0;
                            next_base = {base[0], 2'b10};
                            
                            if (is_top) begin
                                
                                if (top_point_r + base[2] + base[1] > 4'd9) begin
                                    next_top_point_l = (top_point_l == 4'd9 ? 4'd0 : top_point_l + 4'd1);
                                    next_top_point_r = top_point_r + base[2] + base[1] - 4'd10;
                                end
                                else begin
                                    next_top_point_r = top_point_r + base[2] + base[1];
                                end
                                
                            end
                            else begin
                                
                                if (bottom_point_r + base[2] + base[1] > 4'd9) begin
                                    next_bottom_point_l = (bottom_point_l == 4'd9 ? 4'd0 : bottom_point_l + 4'd1);
                                    next_bottom_point_r = bottom_point_r + base[2] + base[1] - 4'd10;
                                end
                                else begin
                                    next_bottom_point_r = bottom_point_r + base[2] + base[1];
                                end
                            end
                            
                        end
                        
                        B3: begin
                            next_strike = 2'b0;
                            next_base = 3'b100;
                            
                            if (is_top) begin
                                
                                if (top_point_r + base[2] + base[1] + base[0] > 4'd9) begin
                                    next_top_point_l = (top_point_l == 4'd9 ? 4'd0 : top_point_l + 4'd1);
                                    next_top_point_r = top_point_r + base[2] + base[1] + base[0] - 4'd10;
                                end
                                else begin
                                    next_top_point_r = top_point_r + base[2] + base[1] + base[0];
                                end
                                
                            end
                            else begin
                                
                                if (bottom_point_r + base[2] + base[1] + base[0] > 4'd9) begin
                                    next_bottom_point_l = (bottom_point_l == 4'd9 ? 4'd0 : bottom_point_l + 4'd1);
                                    next_bottom_point_r = bottom_point_r + base[2] + base[1] + base[0] - 4'd10;
                                end
                                else begin
                                    next_bottom_point_r = bottom_point_r + base[2] + base[1] + base[0];
                                end
                            end
                        end
                        
                        OUT: begin
                            next_strike = 2'b0;
                            next_out = out + 2'b1;
                        end
                        
                        HR: begin
                            next_strike = 2'b0;
                            next_base = 3'b000;
                            
                            if (is_top) begin
                                
                                if (top_point_r + base[2] + base[1] + base[0] + 4'd1 > 4'd9) begin
                                    next_top_point_l = (top_point_l == 4'd9 ? 4'd0 : top_point_l + 4'd1);
                                    next_top_point_r = top_point_r + base[2] + base[1] + base[0] + 4'd1 - 4'd10;
                                end
                                else begin
                                    next_top_point_r = top_point_r + base[2] + base[1] + base[0] + 4'd1;
                                end
                                
                            end
                            else begin
                                
                                if (bottom_point_r + base[2] + base[1] + base[0] + 4'd1 > 4'd9) begin
                                    next_bottom_point_l = (bottom_point_l == 4'd9 ? 4'd0 : bottom_point_l + 4'd1);
                                    next_bottom_point_r = bottom_point_r + base[2] + base[1] + base[0] + 4'd1 - 4'd10;
                                end
                                else begin
                                    next_bottom_point_r = bottom_point_r + base[2] + base[1] + base[0] + 4'd1;
                                end
                            end
                            
                        end
                        /*
                        default: begin
                            
                        end
                        */ // default above.
                    endcase
                end
                else begin
                    // default above.
                end
                
                if (result == VOID) begin
                    if (hit) begin
                        case (op_hit_signal)
                            6'b100000, 
                            6'b001000: begin 
                                case (hit_result)
                                    3'd0,
                                    3'd1,
                                    3'd2,
                                    3'd3,
                                    3'd4: next_result = B1;
                                    3'd5,
                                    3'd6: next_result = B2;
                                    3'd7: next_result = B3;
                                endcase
                            end
                            6'b010000: next_result = STRIKE;
                            6'b000100,
                            6'b000001: next_result = OUT;
                            6'b000010: next_result = HR;
                            default: next_result = VOID;
                        endcase
                    end
                    else begin
                        if (op_BTND) begin
                            case (switch[5:0])
                                6'b100000: next_result = STRIKE;
                                6'b010000: next_result = B1;
                                6'b001000: next_result = B2;
                                6'b000100: next_result = B3;
                                6'b000010: next_result = OUT;
                                6'b000001: next_result = HR;
                                default: next_result = VOID;
                            endcase
                        end
                        else begin
                            next_result = result;
                        end
                    end
                end
                else begin
                    next_result = result;
                end
                
                
                if (result == VOID) begin
                    seg[3] = 8'b00010000;
                    seg[2] = 8'b00010000;
                    seg[1] = 8'b00010000;
                    seg[0] = 8'b00010000;
                end
                else begin
                    
                    seg[3] = 8'b00010000;
                    seg[2] = 8'b00010000;
                    seg[1] = 8'b00010000;
                    seg[0] = 8'b00010000;
                    
                    case (result)
                        STRIKE: begin
                            seg[1] = 8'b11010110;
                            seg[0] = 8'b01011000;
                        end
                        
                        B1: begin
                            seg[1] = 8'b00100100;
                            seg[0] = 8'b01011110;
                        end
                        
                        B2: begin
                            seg[1] = 8'b10111010;
                            seg[0] = 8'b01011110;
                        end
                        
                        B3: begin
                            seg[1] = 8'b10110110;
                            seg[0] = 8'b01011110;
                        end
                        
                        OUT: begin
                            seg[2] = 8'b00011110;
                            seg[1] = 8'b00001110;
                            seg[0] = 8'b01011000;
                        end
                        
                        HR: begin
                            seg[1] = 8'b01111100;
                            seg[0] = 8'b00011000;
                        end
                        
                        default: begin
                            seg[2] = 8'b11011010;
                            seg[1] = 8'b00011000;
                            seg[0] = 8'b00011000;
                        end
                    endcase
                end
                
            end
            
            waiting_reset: begin
                next_state = (out == 2'd3 ? clear : (op_BTNC ? waiting_hit_signal : waiting_reset));
                next_result = VOID;
                
                if (switch[6]) begin
                    seg[3] = top_lnum;
                    seg[2] = top_rnum;
                    seg[1] = bottom_lnum;
                    seg[0] = bottom_rnum;
                end
                else begin
                    seg[3] = {strike != 2'b0, 2'b0, out != 2'b0, 2'b0, base[2], 1'b0};
                    seg[2] = {strike[1], 2'b0, out[1], 2'b0, base[1], 1'b0};
                    seg[1] = {6'b0, base[0], 1'b0};
                    seg[0] = gs_num;
                end
            end
            
            clear: begin
                
                if (out_clear)
                    next_state = (game_stage > finish_stage) ? DONE : waiting_reset;
                else
                    next_state = clear;
                    
                next_strike = out_clear ? 2'b0 : strike;
                next_out = out_clear ? 2'b0 : out;
                next_base = out_clear ? 3'b0 : base;
                
                next_game_stage = half_out_clear ? (!is_top ? game_stage + 4'b1 : game_stage) : game_stage;
                next_is_top = half_out_clear ? ~is_top : is_top;
                
                seg[3] = top_lnum;
                seg[2] = top_rnum;
                seg[1] = bottom_lnum;
                seg[0] = bottom_rnum;
                
            end
            
            DONE: begin
                
                next_s_count = 1'b1;
                
                next_state = (finish ? IDLE : DONE);
                
                if ({top_point_l, top_point_r} > {bottom_point_l, bottom_point_r}) begin
                    seg[3] = top_lnum;
                    seg[2] = top_rnum;
                    seg[1] = 8'b00010000;
                    seg[0] = 8'b00010000;
                end
                
                else if ({top_point_l, top_point_r} < {bottom_point_l, bottom_point_r}) begin
                    seg[3] = 8'b00010000;
                    seg[2] = 8'b00010000;
                    seg[1] = bottom_lnum;
                    seg[0] = bottom_rnum;
                end
                
                else begin
                    seg[3] = top_lnum;
                    seg[2] = top_rnum;
                    seg[1] = bottom_lnum;
                    seg[0] = bottom_rnum;
                end
                
            end
            
        endcase
        
    end
    
    wire [1:0] motor_state;
    wire pitch = (state == waiting_reset) && op_BTNC;
    
    assign eng_l = 2'b10;
    assign eng_r = 2'b01;
    motor m1(clk, op_rst, pitch, eng_en, motor_state);
    counter C(clk, s_count, finish, half_finish);
    counter C2(clk, in_clear, out_clear, half_out_clear);
    
    assign LED = {op_hit_signal, 10'd0};
    
endmodule

module counter(clk, in, out, half);

    input clk, in;
    output out, half;
    
    reg [28:0] count;
    
    always @(posedge clk) begin
        if (!in)
            count <= 29'b0;
        else
            count <= count + 29'b1;
    end
    
    assign half = (count == 29'b0_1000_0000_0000_0000_0000_0000_0000);
    assign out = count[28];
    
endmodule

module remote_display_counter(clk, rst, out);
    input clk, rst;
    output out;
    
    reg [29:0] count;
    
    always @(posedge clk) begin
        if (rst) begin
            count <= 30'd0;
        end
        else begin
            count <= count + 30'd1;
        end
    end
    
    assign out = count[29];
    
endmodule

module debounce(clk, in, out);
    
    input clk, in;
    output out;
    
    reg [2000:0] DFF;
    
    always @(posedge clk) begin
        DFF <= {in, DFF[2000:1]};
    end
    
    assign out = &DFF;
    
endmodule

module onepulse(clk, in, out);

    input clk, in;
    output reg out;
    
    reg delay;
    
    always @(posedge clk) begin
        delay <= in;
        out <= (~delay) && in;
    end
    
endmodule

module convert_num(in, point, out);
    input [3:0] in;
    input point;
    output reg [7:0] out;
    
    always @(*) begin
        
        case ({point, in})
            5'd0: out = 8'b11101110;
            5'd1: out = 8'b00100100;
            5'd2: out = 8'b10111010;
            5'd3: out = 8'b10110110;
            5'd4: out = 8'b01110100;
            5'd5: out = 8'b11010110;
            5'd6: out = 8'b11011110;
            5'd7: out = 8'b10100100;
            5'd8: out = 8'b11111110;
            5'd9: out = 8'b11110110;
            
            5'd16: out = 8'b11101111;
            5'd17: out = 8'b00100101;
            5'd18: out = 8'b10111011;
            5'd19: out = 8'b10110111;
            5'd20: out = 8'b01110101;
            5'd21: out = 8'b11010111;
            5'd22: out = 8'b11011111;
            5'd23: out = 8'b10100101;
            5'd24: out = 8'b11111111;
            5'd25: out = 8'b11110111;
        endcase
    
    end
endmodule