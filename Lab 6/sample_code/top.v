module Top(
    input clk,
    input rst,
    // input echo,
    input [2:0] signal,
    // output trig,
    output left_motor,
    output reg [1:0] left,
    output right_motor,
    output reg [1:0] right,
    output [3:0] PA,
    output [7:0] digit
);
    
    assign PA = 4'b1110;
    
    reg [2:0] state;
    // 0 left ----- right 5
    
    wire Rst_n, rst_pb, stop;
    debounce d0(rst_pb, rst, clk);
    onepulse d1(rst_pb, clk, Rst_n);

    motor A(
        .clk(clk),
        .rst(rst),
        .mode(state),
        .pwm({left_motor, right_motor})
    );
    
    /*
    sonic_top B(
        .clk(), 
        .rst(), 
        .Echo(), 
        .Trig(),
        .stop()
    );
    */
    
    tracker_sensor C(
        .clk(clk), 
        .reset(rst), 
        .signal(signal), 
        .state(state)
       );

    always @(*) begin
        left = 2'b10;
        right = 2'b10;
        // [TO-DO] Use left and right to set your pwm
        //if(stop) {left, right} = ???;
        //else  {left, right} = ???;
        case (state)
            3'd0: 8'b00010001;
            3'd1: 8'b11011011;
            3'd2: 8'b01000101;
            3'd3: 8'b01001001;
            3'd4: 8'b10001011;
            3'd5: 8'b00101001;
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
