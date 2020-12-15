`timescale 1ns/1ps
module tracker_sensor(clk, reset, signal, state);
    input clk;
    input reset;
    input [2:0] signal;
    
    output reg [2:0] state;
    
    parameter LLLLEFT = 3'd0;
    parameter LEFT = 3'd1;
    parameter left = 3'd2;
    parameter right = 3'd3;
    parameter RIGHT = 3'd4;
    parameter RRRRIGHT = 3'd5;
    
    reg [2:0] next_state;
    reg [29:0] count, next_count;
    
    wire start = (state == LEFT || state == RIGHT);
    
    always @(posedge clk) begin
        if (reset) begin
            state <= Straight;
            count <= 30'b0;
        end
        else begin
            state <= next_state;
            count <= (start ? count + 30'b1 : 30'b0);
        end
    end
    
    always @(*) begin
        case (state)
            LLLLEFT: begin // 000 too long!
                next_state = (signal != 3'000 ? left : LLLLEFT);
            end
            LEFT: begin // 000
                next_state = (signal != 3'b000 ? left : (count >= 30'd60000000 ? LLLLEFT : LEFT));
            end
            left: begin // 100
                next_state = (signal == 3'b100 ? left : (signal == 3'b000 ? LEFT : right));
            end
            right: begin    // 110
                next_state = (signal == 3'b110 ? right : (signal == 3'b111 ? RIGHT : left));
            end
            RIGHT: begin    // 111
                next_state = (signal != 3'b111 ? right : (count >= 30'd60000000 ? RRRRIGHT : RIGHT));
            end
            RRRRIGHT: begin // 111 too long!
                next_state = (signal != 3'111 ? right : RRRRIGHT);
            end
        endcase
    end
    
    // [TO-DO] Receive three signals and make your own policy.
    // Hint: You can use output state to change your action.

endmodule
