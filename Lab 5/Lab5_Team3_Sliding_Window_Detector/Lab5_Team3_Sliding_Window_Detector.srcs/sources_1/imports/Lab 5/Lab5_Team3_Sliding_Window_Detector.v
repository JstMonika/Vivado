`timescale 1ns/1ps

module Sliding_Window_Detector (clk, rst_n, in, dec1, dec2);
    input clk, rst_n;
    input in;
    output reg dec1, dec2;
    
    parameter IDLE = 4'd0;
    parameter S0 = 4'd1;    // 1
    parameter S1 = 4'd2;    // 11
    parameter S2 = 4'd3;    // 111
    parameter S3 = 4'd4;    // 10
    parameter S4 = 4'd5;    // 110
    parameter STOP = 4'd6;
    
    reg [3:0] Fstate, Fnext_state;
    reg [3:0] Sstate, Snext_state;
    
    always @(posedge clk) begin
        if (!rst_n) begin
            Fstate <= IDLE;
            Sstate <= IDLE;
        end
        else begin
            Fstate <= Fnext_state;
            Sstate <= Snext_state;
        end
    end
    
    always @(*) begin
        case (Fstate)
            IDLE: begin
                Fnext_state = (in ? S0 : IDLE);
                dec1 = 0;
            end
            S0: begin   // 1
                Fnext_state = (in ? S1 : S3);
                dec1 = 0;
            end
            S1: begin   // 11
                Fnext_state = (in ? S2 : S3);
                dec1 = 0;
            end
            S2: begin   // 111
                Fnext_state = (in ? STOP : S3);
                dec1 = 0;
            end
            S3: begin
                Fnext_state = (in ? S0 : IDLE);
                dec1 = in;
            end
            STOP: begin
                Fnext_state = STOP;
                dec1 = 0;
            end
        endcase
        
        case (Sstate)
            IDLE: begin
                Snext_state = (in ? S0 : IDLE);
                dec2 = 0;
            end
            S0: begin
                Snext_state = (in ? S1 : IDLE);
                dec2 = 0;
            end
            S1: begin
                Snext_state = (in ? S1 : S4);
                dec2 = 0;
            end
            S4: begin
                Snext_state = (in ? S0 : IDLE);
                dec2 = in;
            end
            
        endcase
    end
    
endmodule
