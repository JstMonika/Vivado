`timescale 1ns/1ps 

module Parameterized_Ping_Pong_Counter (clk, rst_n, enable, flip, max, min, direction, out);
input clk, rst_n;
input enable;
input flip;
input [4-1:0] max;
input [4-1:0] min;
output reg direction;
output reg [4-1:0] out;

always @(posedge clk) begin
    
    if (!rst_n) begin
        out <= min;
        direction <= 1'b1;
    end
    else begin
        if (enable && out <= max && out >= min && max != min) begin
            if (direction ^ flip) begin
                if (max == out) begin
                    out <= out - 1'b1;
                    direction <= ~direction;
                end
                else begin
                    out = out + 1'b1;
                    
                    if (flip)
                        direction <= ~direction;
                    else
                        direction <= direction;
                end
            end
            else begin
                if (min == out) begin
                    out <= out + 1'b1;
                    direction <= ~direction;
                end
                else
                    out <= out - 1'b1;
                    
                    if (flip)
                        direction <= ~direction;
                    else
                        direction <= direction;
            end
        end
        else begin
            out <= out;
            direction <= direction;
        end
    end
end

endmodule
