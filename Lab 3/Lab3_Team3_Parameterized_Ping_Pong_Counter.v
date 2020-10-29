`timescale 1ns/1ps 

module Parameterized_Ping_Pong_Counter (clk, rst_n, enable, flip, max, min, direction, out);
input clk, rst_n;
input enable;
input flip;
input [4-1:0] max;
input [4-1:0] min;
output reg direction;
output reg [4-1:0] out;

reg [3:0] next_out;
reg next_direction;

always @(posedge clk) begin
    
    if (!rst_n) begin
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
        if ((direction && (out == max)) || (!direction && (out == min)) || flip)
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
endmodule
