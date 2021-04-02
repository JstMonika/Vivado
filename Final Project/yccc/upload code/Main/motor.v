module motor(
    input clk,
    input rst,
    input trigger,
    output [1:0] pwm,
    output [1:0] state
);
    
    parameter IDLE = 2'd0;
    parameter wait_run = 2'd1;
    parameter run = 2'd2;
    reg [1:0] state, next_state;
    
    wire finish1, finish2;
    assign_counter ac1(clk, start, finish1, finish2);
    
    reg start;
    
    reg [9:0]next_left_motor, next_right_motor;
    reg [9:0]left_motor, right_motor;
    wire left_pwm, right_pwm;

    motor_pwm m0(clk, rst, left_motor, left_pwm);
    motor_pwm m1(clk, rst, right_motor, right_pwm);
    
    always@(posedge clk)begin
        if(rst)begin
            state <= IDLE;
            left_motor <= 10'd0;
            right_motor <= 10'd0;
        end else begin
            state <= next_state;
            left_motor <= next_left_motor;
            right_motor <= next_right_motor;
        end
    end
    
    // [TO-DO] take the right speed for different situation
    always @(*) begin
        
        case (state)
        
            IDLE: begin
                next_state = (trigger ? wait_run : IDLE);
                start = 1'b0;
                
                next_left_motor = 10'd0;
                next_right_motor = 10'd0;
            end
            
            wait_run: begin
                next_state = (finish1 ? run : wait_run);
                start = 1'b1;
                
                next_left_motor = 10'd0;
                next_right_motor = 10'd0;
            end
            
            run: begin
                next_state = (finish2 ? IDLE : run);
                start = 1'b1;
                
                next_left_motor = 10'd1023;
                next_right_motor = 10'd1023;
            end
            
        endcase
        
    end

    assign pwm = {left_pwm,right_pwm};
endmodule

module assign_counter(clk, trigger, out1, out2);
    
    input clk, trigger;
    output out1, out2;
    
    reg [29:0] counter;
    always @(posedge clk) begin
        if (!trigger) begin
            counter <= 30'd0;
        end
        else begin
            counter <= counter + 30'd1;
        end
    end
    
    assign out1 = (counter == 30'd200000000);
    assign out2 = (counter == 30'd250000000);
    
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