`timescale 1ns/1ps

module Ping_Pong_Counter (clk, rst_n, enable, direction, out);
input clk, rst_n;
input enable;
output reg direction;
output reg [4-1:0] out;


always @(posedge clk) begin
    
    if (!rst_n) begin
        out <= 4'b0001;
    end
    
    if (enable) begin
        if (direction == 1'b1) begin
            if (out == 4'd15) begin
                out <= out - 1;
                direction <= ~direction;
            end
            else
                out <= out + 1;
        end
        else
            if (out == 4'd0) begin
                out <= out + 1;
                direction <= ~direction;
            end
            else
                out <= out - 1;
        end
    end
end

endmodule
