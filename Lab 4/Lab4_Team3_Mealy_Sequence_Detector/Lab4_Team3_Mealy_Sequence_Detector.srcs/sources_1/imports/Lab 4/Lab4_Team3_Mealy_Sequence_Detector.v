`timescale 1ns/1ps

module Mealy_Sequence_Detector (clk, rst_n, in, dec);
    input clk, rst_n;
    input in;
    output reg dec;
    
    parameter IDLE = 4'd0;
    parameter S0 = 4'd1;    // 0
    parameter S1 = 4'd2;    // 1
    parameter S2 = 4'd3;    // 00
    parameter S3 = 4'd4;    // 10
    parameter S4 = 4'd5;    // 101
    parameter S5 = 4'd6;    // 001
    parameter F2 = 4'd7;    // fail.
    parameter F1 = 4'd8;    // fail.
    
    reg [3:0] state, next_state;
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
        end
        else begin
            state <= next_state;
        end
    end
    // S0 1 S1 0 S2 1 S3 1 
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (in ? S1 : S0);
                dec = 1'b0;
            end
            S0: begin
                next_state = (in ? F2 : S2);
                dec = 1'b0;
            end
            S1: begin
                next_state = (in ? F2 : S3);
                dec = 1'b0;
            end
            S2: begin
                next_state = (in ? S5 : F1);
                dec = 1'b0;
            end
            S3: begin
                next_state = (in ? S4 : F1);
                dec = 1'b0;
            end
            S4: begin
                next_state = IDLE;
                dec = 1'b1;
            end
            S5: begin
                next_state = IDLE;
                dec = in;
            end
            F1: begin
                next_state = IDLE;
                dec = 1'b0;
            end
            F2: begin
                next_state = F1;
                dec = 1'b0;
            end
            default: begin
                next_state = IDLE;
                dec = 1'b0;
            end
            
        endcase
    end
endmodule
