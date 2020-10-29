`timescale 1ns/1ps

module Mealy (clk, rst_n, in, out, state);
input clk, rst_n;
input in;
output reg out;
output reg [3-1:0] state;
reg [2:0] next;

parameter S0 = 3'b000;
parameter S1 = 2'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;

always @(*) begin
    case (state)
        S0: begin
            next = in ? S2 : S0;
            out = in;
        end
        S1: begin
            next = in ? S4 : S0;
            out = 1;
        end
        S2: begin
            next = in ? S1 : S5;
            out = ~in;
        end
        S3: begin
            next = in ? S2 : S3;
            out = ~in;
        end
        S4: begin
            next = in ? S4 : S2;
            out = 1;
        end
        S5: begin
            next = in ? S4 : S3;
            out = 0;
        end
        
    endcase
end

always @(posedge clk) begin
    if (!rst_n)
        state <= S0;
    else
        state <= next;
end

endmodule
