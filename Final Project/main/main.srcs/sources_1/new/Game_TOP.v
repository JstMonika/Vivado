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

// TODO: signal list
module Game_TOP(
    input clk, // W5
    input rst, // T18
    input [7:0] hit_signal, // pins
    input BTNC, // U18
    input BTNL, // W19
    input BTNR, // T17
    input BTND, // U17
    input [15:0] switch,
    
    output [15:0] LED,
    output [31:0] display,
    output [1:0] eng_en,
    output [1:0] eng_l,
    output [1:0] eng_r
    
    
    // output display.
);
    
    // TODO: instance of array available?
    wire de_rst, op_rst;
    debounce drst(clk, rst, de_rst);
    onepulse orst(clk, de_rst, op_rst);
    
    wire [7:0] de_hit_signal, op_hit_signal;
    debounce dhs [7:0] (clk, hit_signal, de_hit_signal);
    onepulse ohs [7:0] (clk, de_hit_signal, op_hit_signal);
    
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
    
    // TODO: change?
    parameter IDLE = 4'd0;
    parameter waiting_hit_signal = 4'd1;
    parameter waiting_reset = 4'd2;
    parameter clear = 4'd3;
    parameter DONE = 4'd4;
    // parameter 
    
    reg [3:0] game_stage, next_game_stage;    // 1st ~ 9th.
    reg [3:0] select_stage, next_select_stage;
    reg [3:0] finish_stage, next_finish_stage;
    reg [6:0] top_point, next_top_point;
    reg [6:0] bottom_point, next_bottom_point;
    // TODO: is_top
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
    wire finish;
    
    reg [3:0] state, next_state;
    
    // FIXME:
    assign LED[1:0] = out;
    assign LED[3:2] = strike;
    assign LED[6:4] = base;
    
    assign LED[15:12] = state;
    assign LED[7] = is_top;
    assign LED[11:8] = game_stage;
    
    always @(posedge clk) begin
        if (op_rst) begin
            state <= IDLE;
            game_stage <= 4'b0;
            select_stage <= 4'b0;
            finish_stage <= 4'd3;
            strike <= 2'b0;
            out <= 2'b0;
            s_count <= 1'b0;
            result <= VOID;
            is_top <= 1'b0;
        end
        else begin
            state <= next_state;
            game_stage = next_game_stage;
            select_stage <= next_select_stage;
            finish_stage <= next_finish_stage;
            strike <= next_strike;
            out <= next_out;
            s_count <= next_s_count;
            result <= next_result;
            is_top <= next_is_top;
        end
    end
    
    always @(*) begin
        
        case ({BTNL, BTNR})
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
        next_finish_stage = finish_stage;
        next_strike = strike;
        next_out = out;
        next_base = base;
        next_top_point = top_point;
        next_bottom_point = bottom_point;
        next_s_count = 1'b0;
        hit = |op_hit_signal;
        next_result = result;
        record_hit_finish = (result != VOID);
        
        // TODO: next_state
        case (state)
            IDLE: begin
                next_state = (op_BTNC ? waiting_reset : IDLE);
                next_finish_stage = (op_BTNC ? select_stage : finish_stage);
                
                next_strike = 2'b0;
                next_out = 2'b0;
                next_base = 3'b0;
                next_is_top = (op_BTNC ? 1'b1 : 1'b0);
                next_game_stage = 4'd1;
            end
            
            waiting_hit_signal: begin
                next_state = (record_hit_finish && finish) ? waiting_reset : waiting_hit_signal;
                next_s_count = hit ? 1'b1 : s_count;
                
                if (record_hit_finish) begin
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
                            next_base = {base[1:0], 1'b1};
                            
                            if (is_top) begin
                                next_top_point = top_point + base[2];
                            end
                            else begin
                                next_bottom_point = bottom_point + base[2];
                            end
                        end
                        
                        B2: begin
                            next_base = {base[0], 2'b10};
                            
                            if (is_top) begin
                                next_top_point = top_point + base[2] + base[1];
                            end
                            else begin
                                next_bottom_point = bottom_point + base[2] + base[1];
                            end
                        end
                        
                        B3: begin
                            next_base = 3'b100;
                            
                            if (is_top) begin
                                next_top_point = top_point + base[2] + base[1] + base[0];
                            end
                            else begin
                                next_bottom_point = bottom_point + base[2] + base[1] + base[0];
                            end
                        end
                        
                        OUT: begin
                            next_out = out + 2'b1;
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
                            8'b10000000: next_result = STRIKE;
                            8'b01000000: next_result = B1;
                            8'b00100000,
                            8'b00010000: next_result = B2;
                            8'b00001000: next_result = B3;
                            8'b00000100,
                            8'b00000010: next_result = OUT;
                            8'b00000001: next_result = HR;
                            default: next_result = VOID;
                        endcase
                    end
                    else begin
                        if (op_BTND) begin
                            case (switch[15:10])
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
                
                
            end
            
            waiting_reset: begin
                next_state = (out == 2'd3 ? clear : (op_BTNC ? waiting_hit_signal : waiting_reset));
                next_result = VOID;
            end
            
            // TODO: finish.
            clear: begin
                next_s_count = finish ? 1'b0 : 1'b1;
                
                if (finish)
                    next_state = (game_stage == finish_stage && is_top == 1'b0) ? DONE : waiting_reset;
                else
                    next_state = clear;
                    
                next_strike = finish ? 2'b0 : strike;
                next_out = finish ? 2'b0 : out;
                next_base = finish ? 3'b0 : base;
                next_game_stage = !is_top ? game_stage + 4'b1 : game_stage;
                next_is_top = finish ? ~is_top : is_top;
                
            end
            
            // TODO: done.
            DONE: begin
                next_state = IDLE;
            end
            
        endcase
        
    end
    
    // TODO: turn on engine.
    wire pitch = (state == waiting_reset) && op_BTNC;
    
    // FIXME:
    // wire [1:0] eng_en;  // left, right.
    // wire [1:0] eng_l;
    // wire [1:0] eng_r;
    engine E(clk, pitch, eng_en, eng_l, eng_r);
    
    counter C(clk, s_count, finish);
    
endmodule

// FIXME:
module engine(clk, trigger, en, l, r);
    input clk, trigger;
    output [1:0] en, l, r;
    
    assign en = 2'b00;
    assign l = 2'b00;
    assign r = 2'b00;
endmodule

module counter(clk, in, out);

    input clk, in;
    output out;
    
    reg [28:0] count;
    
    always @(posedge clk) begin
        if (!in)
            count <= count;
        else
            count <= count + 29'b1;
    end
    
    assign out = count[28];
    
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

module onepulse(clk, in, out);

    input clk, in;
    output reg out;
    
    reg delay;
    
    always @(posedge clk) begin
        delay <= in;
        out <= (~delay) && in;
    end
    
endmodule