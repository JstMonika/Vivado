`timescale 1ns/1ps
module tracker_sensor(clk, reset, signal, state);
    input clk;
    input reset;
    input [2:0] signal;
    
    output reg [2:0] state;
    
    parameter Straight = 3'd0;
    // parameter Backward = 3'd1;
    parameter LLLLEFT = 3'd2;
    parameter LEFT = 3'd3;
    parameter RIGHT = 3'd4;
    parameter RRRRIGHT = 3'd5;
    parameter TURN = 3'd6;
    
    reg [2:0] next_state, signal_state;
    reg [29:0] count, next_count;
    
    wire start = (state == TURN && signal != 3'b000);
    
    always @(posedge clk) begin
        if (reset) begin
            count <= 30'b0;
        end
        else begin
            count <= (start ? count + 30'b1 : 30'b0);
        end
    end
    
    always @(*) begin   // 0 is black, 1 is white.
        case (signal)
            3'b000: state = TURN;
            3'b001: state = RRRRIGHT;
            3'b011: state = RIGHT;
            3'b111: state = Straight;
            3'b110: state = LEFT;
            3'b100: state = LLLLEFT;
            default: state = Straight;
        endcase
    end
    
    // [TO-DO] Receive three signals and make your own policy.
    // Hint: You can use output state to change your action.

endmodule
