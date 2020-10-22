`timescale 1ns/1ps 

module Parameterized_Ping_Pong_Counter (clk, rst_n, enable, flip, max, min, display, which);
input clk, rst_n;
input enable;
input flip;
input [4-1:0] max;
input [4-1:0] min;

wire RESET, RST_N;
wire FLIP;
wire disCLK;
wire chaCLK;

output reg [3:0] which;
output reg [7:0] display;
reg [3:0] next_which;
reg [7:0] next_display;
reg direction;
reg next_direction;
reg [4-1:0] out;
reg [3:0] next_out;

de_op do1(clk, clk, rst_n, RESET);
de_op do2(clk, chaCLK, flip, FLIP);
not not1(RST_N, RESET);
dis_clk Clock(clk, RST_N, disCLK);
change_clk Clock2(clk, RST_N, chaCLK);

always @(posedge disCLK) begin
    if (!RST_N) begin
        which <= 4'b0111;
        display <= next_display;
    end
    else begin
        which <= next_which;
        display <= next_display;
    end
end

always @(posedge chaCLK) begin
    
    if (!RST_N) begin
        out <= min;
        direction <= 1'b1;
    end
    else begin
        out <= next_out;
        direction <= next_direction;
    end
end

always @(*) begin
    
    if (enable && out >= min && out <= max && min != max) begin
        if ((direction && (out == max)) || (!direction && (out == min)) || FLIP)
            next_direction = ~direction;
        else
            next_direction = direction;
    end
    else
        next_direction = direction;
        
        
    if (enable && out >= min && out <= max && min != max) begin
        next_out = (next_direction ? out + 1 : out - 1);
    end
    else
        next_out = out;
end

always @(*) begin
    next_which = {which[0], which[3:1]};
    
    case (next_which)
        4'b0111: begin
            next_display[0] = (out < 10) ? 0 : 1;
            next_display[1] = (out < 10) ? 0 : 1;
            next_display[2] = 1'b0;
            next_display[3] = 1'b1;
            next_display[4] = (out < 10) ? 0 : 1;
            next_display[5] = 1'b0;
            next_display[6] = (out < 10) ? 0 : 1;
            next_display[7] = 1'b1;
        end
        4'b1011: begin
            next_display[0] = (out == 1) || (out == 11) || (out == 4) || (out == 14);
            next_display[1] = (out == 1) || (out == 11) || (out == 2) || (out == 12) || (out == 3) || (out == 13) || (out == 7);
            next_display[2] = (out == 5) || (out == 6) || (out == 15);
            next_display[3] = (out == 0) || (out == 10) || (out == 1) || (out == 11) || (out == 7);
            next_display[4] = (!((out == 0) || (out == 10) || (out == 2) || (out == 12) || (out == 6) || (out == 8)));
            next_display[5] = (out == 2) || (out == 12);
            next_display[6] = (out == 1) || (out == 11) || (out == 4) || (out == 14) || (out == 7);
            next_display[7] = 1'b1;
        end
        4'b1101: begin
            next_display[0] = ~direction;
            next_display[1] = ~direction;
            next_display[2] = ~direction;
            next_display[3] = 1'b1;
            next_display[4] = direction;
            next_display[5] = direction;
            next_display[6] = direction;
            next_display[7] = 1'b1;
        end
        4'b1110: begin
            next_display[0] = ~direction;
            next_display[1] = ~direction;
            next_display[2] = ~direction;
            next_display[3] = 1'b1;
            next_display[4] = direction;
            next_display[5] = direction;
            next_display[6] = direction;
            next_display[7] = 1'b1; 
        end
    endcase
end

endmodule

module dis_clk(clk, rst_n, out);
    
    input clk;
    input rst_n;
    output out;
    
    reg [25:0] count;
    
    assign out = (count == 0);
    
    always @(posedge clk)
        if (!rst_n)
            count <= 0;
        else
            // count <= (count >= 2 ? 0 : count + 1);
            count <= (count >= 270000 ? 0 : count + 1);
    
endmodule

module change_clk(clk, rst_n, out);
    
    input clk;
    input rst_n;
    output out;
    
    reg [25:0] count;
    
    assign out = (count == 0);
    
    always @(posedge clk)
        if (!rst_n)
            count <= 0;
        else
            // count <= (count == 5 ? 0 : count + 1);
            count <= (count == 100000000 ? 0 : count + 1);
    
endmodule

module de_op(declk, opclk, sin, sout);
    
    input declk;
    input opclk;
    input sin;
    output reg sout;
    
    reg [4:0] dff;
    
    wire debounce;
    assign debounce = &dff;
    
    reg delay;
    
    always @(negedge declk) begin
        dff[4:0] <= {sin, dff[4:1]};
    end
    
    always @(negedge opclk) begin
        delay <= debounce;
        sout <= (debounce && (~delay));
    end
    
endmodule