`timescale 1ns/1ps

module Greatest_Common_Divisor (clk, rst_n, Begin, a, b, Complete, gcd);
input clk, rst_n;
input Begin;
input [16-1:0] a;
input [16-1:0] b;
output reg Complete;
output reg [16-1:0] gcd;

reg [15:0] ca, cb, next_ca, next_cb;

reg [1:0] state, next_state;
reg count;

parameter WAIT = 2'b00;
parameter CAL = 2'b01;
parameter FINISH = 2'b10;

always @(posedge clk) begin
    if (!rst_n) begin
        state <= WAIT;
    end
    else begin
        state <= next_state;
    end
    
    if (state == WAIT && Begin) begin
        ca <= a;
        cb <= b;
    end
    else begin
        ca <= next_ca;
        cb <= next_cb;
    end
    
    if (state == CAL && cb == 16'b0) begin
        count <= 1'b1;
    end
    else begin
        count <= 1'b0;
    end
end

always @(*) begin
    case (state)
        WAIT: begin
            next_state = (Begin ? CAL : WAIT);
        end
        CAL: begin
            next_state = (cb == 16'b0 ? FINISH : CAL);
        end
        FINISH: begin
            next_state = (count ? FINISH : WAIT);
        end
    endcase
    
    gcd = (state == FINISH ? ca : 16'b0);
    Complete = (state == FINISH ? 1'b1 : 1'b0);
    
    if (ca != 0) begin    
        if (ca > cb) begin
            next_ca = ca - cb;
            next_cb = cb;
        end
        else begin
            next_ca = ca;
            next_cb = cb - ca;
        end
    end
    else begin
        next_ca = cb;
        next_cb = ca;
    end
end

endmodule
