`timescale 1ns/1ps

module Moore (clk, rst_n, in, out, state);
input clk, rst_n;
input in;
output reg [2-1:0] out;
output reg [3-1:0] state;
reg [3-1:0] next_state;

parameter S0 = 3'b000;
parameter S1 = 2'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;

always @(*) begin
    
    case (state)
    
        S0: out = 11;
        S1: out = 1;
        S2: out = 11;
        S3: out = 10;
        S4: out = 10;
        S5: out = 0; 
        default: out = 0;
        
    endcase
    
    case (state)
        
        S0: next_state = in ? S2 : S1;
        S1: next_state = in ? S5 : S4;
        S2: next_state = in ? S3 : S1;
        S3: next_state = in ? S0 : S1;
        S4: next_state = in ? S5 : S4;
        S5: next_state = in ? S0 : S3;
        default: next_state = 0;
        
    endcase
end

always @(posedge clk) begin
    
    if (!rst_n)
        state <= S0;
    else
        state <= next_state;
end

endmodule
