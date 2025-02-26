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
