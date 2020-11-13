`timescale 1ns/1ps

module Mealy_Sequence_Detector (clk, rst_n, in, dec);
    input clk, rst_n;
    input in;
    output reg dec;
    
    parameter IDLE = 4'd0;
    parameter S0 = 4'd1;
    parameter S1 = 4'd2;
    parameter S2 = 4'd3;
    parameter S3 = 4'd4;
    parameter S4 = 4'd5;
    parameter S5 = 4'd6;
    
    reg [3:0] state, next_state;
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= S0;
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
                next_state = (in ? S1 : S4);
                dec = 1'b0;
            end
            S1: begin
                next_state = (in ? S1 : S2);
                dec = 1'b0;
            end
            S2: begin
                next_state = (in ? S3 : S4);
                dec = 1'b0;
            end
            S3: begin
                next_state = (in ? S1 : S2);
                dec = 1'b1;
            end
            S4: begin
                next_state = (in ? S5 : S4);
                dec = 1'b0;
            end
            S5: begin
                next_state = (in ? S1 : S2);
                dec = in;
            end
            default: begin
                next_state = IDLE;
                dec = 1'b0;
            end
            
        endcase
    end
endmodule
