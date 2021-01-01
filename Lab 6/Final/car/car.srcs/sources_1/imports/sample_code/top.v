module Top(
    input clk,
    input rst,
    input echo,
    input [2:0] signal,
    output trig,
    output [1:0] motor,
    output reg [1:0] left,
    output reg [1:0] right,
    output reg [3:0] PA,
    output reg [7:0] digit,
    output stop
);
    
    wire [1:0] motor;
    wire [2:0] state, update_state;
    // 0 left ----- right 5
    
    wire Rst_n, rst_pb, stop;
    debounce d0(rst_pb, rst, clk);
    onepulse d1(rst_pb, clk, Rst_n);


    reg last_left, next_last_left;
    always @(posedge clk) begin
        if (rst) begin
            last_left <= 1'b0;
        end
        else begin
            last_left <= next_last_left;
        end
    end

    motor A(
        .clk(clk),
        .rst(rst),
        .last_left(last_left),
        .mode(update_state),
        .pwm(motor)
    );

    sonic_top B(
        .clk(clk), 
        .rst(rst), 
        .Echo(echo), 
        .Trig(trig),
        .stop(stop)
    );
    
    assign update_state = (stop ? 3'd1 : state);
    
    tracker_sensor C(
        .clk(clk), 
        .reset(rst), 
        .signal(signal), 
        .state(state)
       );

    always @(*) begin
        case (state)
            3'd2: next_last_left = 1'b0;
            3'd3: next_last_left = 1'b0;
            3'd4: next_last_left = 1'b1;
            3'd5: next_last_left = 1'b1;
            default: next_last_left = last_left;
        endcase

        left = (state == 3'd6 && last_left == 1'b0) ? 2'b01 : 2'b10;
        right = (state == 3'd6 && last_left == 1'b1) ? 2'b01 : 2'b10;
            
        // [TO-DO] Use left and right to set your pwm
        //if(stop) {left, right} = ???;
        //else  {left, right} = ???;
        case (update_state)
            3'd0: begin
                digit = 8'b00011111;
                PA = 4'b1110;
            end
            3'd1: begin
                digit = 8'b11101111;
                PA = 4'b1110;
            end
            3'd2: begin
                digit = 8'b11100101;
                PA = 4'b1100;
            end
            3'd3: begin
                digit = 8'b11100101;
                PA = 4'b1110;
            end
            3'd4: begin
                digit = 8'b11101001;
                PA = 4'b1110;
            end
            3'd5: begin
                digit = 8'b11101001;
                PA = 4'b1100;
            end
            3'd6: begin
                digit = 8'b11100001;
                PA = 4'b1110;
            end
            default: begin
                digit = 8'b00100111;
                PA = 4'b1110;
            end
        endcase
    end

endmodule

module debounce (pb_debounced, pb, clk);
    output pb_debounced; 
    input pb;
    input clk;
    reg [4:0] DFF;
    
    always @(posedge clk) begin
        DFF[4:1] <= DFF[3:0];
        DFF[0] <= pb; 
    end
    assign pb_debounced = (&(DFF)); 
endmodule

module onepulse (PB_debounced, clk, PB_one_pulse);
    input PB_debounced;
    input clk;
    output reg PB_one_pulse;
    reg PB_debounced_delay;

    always @(posedge clk) begin
        PB_one_pulse <= PB_debounced & (! PB_debounced_delay);
        PB_debounced_delay <= PB_debounced;
    end 
endmodule
