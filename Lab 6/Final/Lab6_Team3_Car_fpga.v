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
    
    
    tracker_sensor C(
        .clk(clk), 
        .reset(rst), 
        .signal(signal), 
        .state(state)
       );
    assign update_state = (stop ? 3'd1 : state);

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

module tracker_sensor(clk, reset, signal, state);
    input clk;
    input reset;
    input [2:0] signal;
    
    output reg [2:0] state;
    
    parameter Straight = 3'd0;
    // parameter Stop = 3'd1;
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

module motor(
    input clk,
    input rst,
    input last_left,
    input [2:0] mode,
    output  [1:0]pwm
);

    reg [9:0]next_left_motor, next_right_motor;
    reg [9:0]left_motor, right_motor;
    wire left_pwm, right_pwm;

    motor_pwm m0(clk, rst, left_motor, left_pwm);
    motor_pwm m1(clk, rst, right_motor, right_pwm);

    always@(posedge clk)begin
        if(rst)begin
            left_motor <= 10'd0;
            right_motor <= 10'd0;
        end else begin
            left_motor <= next_left_motor;
            right_motor <= next_right_motor;
        end
    end
    
    // [TO-DO] take the right speed for different situation
    always @(*) begin
        case (mode)
        
        3'd0: begin
            next_left_motor = 10'd1023;
            next_right_motor = 10'd1023;
        end

        3'd1: begin
            next_left_motor = 10'd0;
            next_right_motor = 10'd0;
        end
            
        3'd2: begin
            next_left_motor = 10'd470;
            next_right_motor = 10'd1023;
        end
            
        3'd3: begin
            next_left_motor = 10'd670;
            next_right_motor = 10'd1023;
        end
         
        3'd4: begin
            next_left_motor = 10'd1023;
            next_right_motor = 10'd670;
        end
            
        3'd5: begin
            next_left_motor = 10'd1023;
            next_right_motor = 10'd470;
        end
          
        3'd6: begin
            next_left_motor = (last_left ? 10'd1023 : 10'd800);
            next_right_motor = (last_left ? 10'd800 : 10'd1023);
        end
        
        endcase
    end

    assign pwm = {left_pwm,right_pwm};
endmodule

module motor_pwm (
    input clk,
    input reset,
    input [9:0]duty,
	output pmod_1 //PWM
);
        
    PWM_gen pwm_0 ( 
        .clk(clk), 
        .reset(reset), 
        .freq(32'd25000),
        .duty(duty), 
        .PWM(pmod_1)
    );

endmodule

//generte PWM by input frequency & duty
module PWM_gen (
    input wire clk,
    input wire reset,
	input [31:0] freq,
    input [9:0] duty,
    output reg PWM
);
    wire [31:0] count_max = 100_000_000 / freq;
    wire [31:0] count_duty = count_max * duty / 1024;
    reg [31:0] count;
        
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            count <= 0;
            PWM <= 0;
        end else if (count < count_max) begin
            count <= count + 1;
            if(count < count_duty)
                PWM <= 1;
            else
                PWM <= 0;
        end else begin
            count <= 0;
            PWM <= 0;
        end
    end
endmodule

module sonic_top(clk, rst, Echo, Trig, stop);
	input clk, rst, Echo;
	output Trig, stop;

	wire[19:0] dis;
	wire[19:0] d;
    wire clk1M;
	wire clk_2_17;

    div clk1(clk ,clk1M);
	TrigSignal u1(.clk(clk), .rst(rst), .trig(Trig));
	PosCounter u2(.clk(clk1M), .rst(rst), .echo(Echo), .distance_count(dis));
    
    assign stop = dis < 20'd4000;

    // [TO-DO] calculate the right distance to trig stop(triggered when the distance is lower than 40 cm)
    // Hint: using "dis"
 
endmodule

module PosCounter(clk, rst, echo, distance_count); 
    input clk, rst, echo;
    output[19:0] distance_count;

    parameter S0 = 2'b00;
    parameter S1 = 2'b01; 
    parameter S2 = 2'b10;
    
    wire start, finish;
    reg[1:0] curr_state, next_state;
    reg echo_reg1, echo_reg2;
    reg[19:0] count, distance_register;
    wire[19:0] distance_count; 

    always@(posedge clk) begin
        if(rst) begin
            echo_reg1 <= 0;
            echo_reg2 <= 0;
            count <= 0;
            distance_register  <= 0;
            curr_state <= S0;
        end
        else begin
            echo_reg1 <= echo;   
            echo_reg2 <= echo_reg1; 
            case(curr_state)
                S0:begin
                    if (start) curr_state <= next_state; //S1
                    else count <= 0;
                end
                S1:begin
                    if (finish) curr_state <= next_state; //S2
                    else count <= count + 1;
                end
                S2:begin
                    distance_register <= count;
                    count <= 0;
                    curr_state <= next_state; //S0
                end
            endcase
        end
    end

    always @(*) begin
        case(curr_state)
            S0:next_state = S1;
            S1:next_state = S2;
            S2:next_state = S0;
        endcase
    end

    assign distance_count = distance_register  * 100 / 58; 
    assign start = echo_reg1 & ~echo_reg2;  
    assign finish = ~echo_reg1 & echo_reg2; 
endmodule

module TrigSignal(clk, rst, trig);
    input clk, rst;
    output trig;

    reg trig, next_trig;
    reg[23:0] count, next_count;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            count <= 0;
            trig <= 0;
        end
        else begin
            count <= next_count;
            trig <= next_trig;
        end
    end

    always @(*) begin
        next_trig = trig;
        next_count = count + 1;
        if(count == 999)
            next_trig = 0;
        else if(count == 24'd9999999) begin
            next_trig = 1;
            next_count = 0;
        end
    end
endmodule

module div(clk ,out_clk);
    input clk;
    output out_clk;
    reg out_clk;
    reg [6:0]cnt;
    
    always @(posedge clk) begin   
        if(cnt < 7'd50) begin
            cnt <= cnt + 1'b1;
            out_clk <= 1'b1;
        end 
        else if(cnt < 7'd100) begin
	        cnt <= cnt + 1'b1;
	        out_clk <= 1'b0;
        end
        else if(cnt == 7'd100) begin
            cnt <= 0;
            out_clk <= 1'b1;
        end
    end
endmodule