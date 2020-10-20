`timescale 1ns/1ps 

module Parameterized_Ping_Pong_Counter (clk, rst_n, enable, flip, max, min, display, decoder);
input clk, rst_n;
input enable;
input flip;
input [4-1:0] max;
input [4-1:0] min;

output [3:0] decoder;
reg [1:0] count = 0;
output [7:0] display;

assign display[0] = count == 0 ? !(out < 10) :
                    count == 1 ? (out == 1) | (out == 4) : ~direction;
assign display[1] = count == 0 ? !(out < 10) :
                    count == 1 ? (out == 1) | (out == 2) | (out == 3) | (out == 7) : ~direction;
assign display[2] = count == 0 ? 1'b0 :
                    count == 1 ? (out == 5) | (out == 6) : ~direction;
assign display[3] = count == 0 ? 1'b1 :
                    count == 1 ? (out == 1) | (out == 7) | (out == 0) : 1'b1;
assign display[4] = count == 0 ? !(out < 10) :
                    count == 1 ? (!((out == 2) | (out == 6) | (out == 8) | (out == 0))) : direction;
assign display[5] = count == 0 ? 1'b0 :
                    count == 1 ? (out == 2) : direction;
assign display[6] = count == 0 ? !(out < 10) :
                    count == 1 ? (out == 1) | (out == 4) | (out == 7) : direction;
assign display[7] = 1'b1;

assign decoder = count == 0 ? 7 :
                 count == 1 ? 11 :
                 count == 2 ? 13 : 14;

reg direction = 1;
reg [4-1:0] out = 0;

reg [4:0] flipDFF, rstDFF;
wire dflip, drst_n;
reg delay_flip, delay_rst, opul_flip, opul_rst;

always @(posedge clk) begin
    flipDFF[4:0] <= {flip, flipDFF[4:1]};
    rstDFF[4:0] <= {rst_n, rstDFF[4:1]};
    
    delay_flip <= dflip;
    delay_rst <= drst_n;
    
    opul_flip <= dflip & (!delay_flip);
    opul_rst <= (!(drst_n & (!delay_rst)));
    
    // ---------------------
    count <= (count == 3 ? 0 : count + 1);
end

assign dflip = &flipDFF;
assign drst_n = &rstDFF;

wire sclk;
sec_clk s1(.clk(clk), .out(sclk));

always @(posedge sclk) begin
    
    if (!opul_rst) begin
        out <= min;
        direction <= 1'b1;
    end
    else begin
        if (enable && out <= max && out >= min && max != min) begin
            if (direction ^ opul_flip) begin
                if (max == out) begin
                    out <= out - 1'b1;
                    direction <= ~direction;
                end
                else begin
                    out = out + 1'b1;
                    
                    if (opul_flip)
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
                else begin
                    out <= out - 1'b1;
                    
                    if (opul_flip)
                        direction <= ~direction;
                    else
                        direction <= direction;
                end
            end
        end
        else begin
            out <= out;
            direction <= direction;
        end
    end
end

endmodule

module sec_clk(clk, out);
    input clk;
    output reg out = 0;
    
    reg [18:0] counter = 0;
    
    always @(posedge clk) begin
        if (counter == 50000) begin
            counter <= 0;
            out <= ~out;
        end
        else begin
            counter = counter + 1;
            out <= out;
        end
    end
    
endmodule
