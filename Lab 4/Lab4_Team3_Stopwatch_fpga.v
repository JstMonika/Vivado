`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/09/2020 09:32:07 PM
// Design Name: 
// Module Name: Lab4_Team3_Stopwatch_fpga
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Lab4_Team3_Stopwatch_fpga(clk, rst_n, trigger, display, led);
    
    // basic input.
    input clk, rst_n, trigger;
    
    // debounce, onepulse, inverter.
    wire neg_rst, de_rst_n, op_rst_n;
    wire dis_clk, cha_clk;
    wire de_trigger, op_trigger;
    
    // current time, next time.
    reg [3:0] min, tsec, sec, dsec;
    reg [3:0] nmin, ntsec, nsec, ndsec;
    
    // display.
    output reg [3:0] led;
    output reg [7:0] display;
    reg [7:0] next_display;
    
    // parameter.
    parameter one = 7'b1101101;
    parameter two = 7'b0100010;
    parameter three = 7'b0100100;
    parameter four = 7'b1000101;
    parameter five = 7'b0010100;
    parameter six = 7'b0010000;
    parameter seven = 7'b0001101;
    parameter eight = 7'b0000000;
    parameter nine = 7'b0000100;
    parameter zero = 7'b0001000;
    
    debounce derst(clk, rst_n, de_rst_n);
    onePulse oprst(clk, dis_clk, de_rst_n, op_rst_n);
    assign neg_rst = ~de_rst_n;
    
    debounce detri(clk, trigger, de_trigger);
    onePulse optri(clk, cha_clk, de_trigger, op_trigger);
    
    div_clk d1(clk, neg_rst, dis_clk, 30'd270000);
    div_clk d2(clk, neg_rst, cha_clk, 30'd10000000);
    
    always @(posedge clk) begin
        if (cha_clk) begin
            if (!neg_rst) begin
                state <= IDLE;
                {min, tsec, sec, dsec} <= 16'b0;
            end
            else begin
                state <= next_state;
                {min, tsec, sec, dsec} <= {nmin, ntsec, nsec, ndsec};
            end
        end
        else begin
            state <= state;
            {min, tsec, sec, dsec} <= {min, tsec, sec, dsec};
        end
    
        if (dis_clk) begin
            if (op_rst_n) begin
                led <= 4'b0111;
                display <= {nmin, 1'b1};
            end
            else begin
                led <= {led[0], led[3:1]};
                display <= next_display;
            end
        end
        else begin
            led <= led;
            display <= display;
        end
    end
    
    parameter IDLE = 2'b00;
    parameter RUN = 2'b01;
    parameter WAIT = 2'b10;
    reg [1:0] state;
    reg [1:0] next_state;
    
    reg [3:0] choose;
    reg dot;
    always @(*) begin
        case (led)
            4'b0111: begin
                choose = ntsec;
                dot = 1'b1;
            end
            4'b1011: begin
                choose = nsec;
                dot = 1'b0;
            end
            4'b1101: begin
                choose = ndsec;
                dot = 1'b1;
            end
            4'b1110: begin
                choose = nmin;
                dot = 1'b1;
            end
        endcase
        
        case (choose)
            4'd0: next_display = {zero, dot};
            4'd1: next_display = {one, dot};
            4'd2: next_display = {two, dot};
            4'd3: next_display = {three, dot};
            4'd4: next_display = {four, dot};
            4'd5: next_display = {five, dot};
            4'd6: next_display = {six, dot};
            4'd7: next_display = {seven, dot};
            4'd8: next_display = {eight, dot};
            4'd9: next_display = {nine, dot};
        endcase
        
        case (state)
            IDLE: begin
                next_state = (op_trigger ? RUN : IDLE);
                
                ndsec = dsec;
                nsec = sec;
                ntsec = tsec;
                nmin = min;
            end
            RUN: begin
                if ({nmin, ntsec, nsec, ndsec} == 16'b0)
                    next_state = IDLE;
                else
                    next_state = (op_trigger ? WAIT : RUN);
                    
                ndsec = (dsec == 4'd9 ? 4'b0 : dsec + 4'b1);
                
                if (dsec == 4'd9)
                    nsec = (sec == 4'd9 ? 4'b0 : sec + 4'b1);
                else
                    nsec = sec;
                    
                if (dsec == 4'd9 && sec == 4'd9)
                    ntsec = (tsec == 4'd5 ? 4'b0 : tsec + 4'b1);
                else
                    ntsec = tsec;
                    
                if (dsec == 4'd9 && sec == 4'd9 && tsec == 4'd5)
                    nmin = (min == 4'd9 ? 4'b0 : min + 4'b1);
                else
                    nmin = min;   
                    
            end
            WAIT: begin
                next_state = (op_trigger ? RUN : WAIT);
                
                ndsec = dsec;
                nsec = sec;
                ntsec = tsec;
                nmin = min;
            end
        endcase
        
    end
    
endmodule

module debounce(clk, in, out);
    
    input clk, in;
    output out;
    
    reg [29:0] DFF;
    assign out = &DFF;
    
    always @(posedge clk) DFF <= {in, DFF[29:1]};
    
endmodule

module onePulse(clk, check, in, out);

    input clk, check, in;
    output reg out;
    
    reg delay;
    always @(posedge clk) begin
        if (check == 1'b1) begin
            delay <= in;
            out <= (in && ~delay);
        end
        else begin
            delay <= delay;
            out <= out;
        end
    end
    
endmodule

module div_clk(clk, rst_n, out, div);

    input clk, rst_n;
    input [29:0] div;
    output out;
    
    assign out = (counter == 30'b0);
    reg [29:0] counter;
    
    always @(posedge clk) begin
        if (!rst_n)
            counter <= 30'b0;
        else
            counter <= (counter == div ? 30'b0 : counter + 30'b1);
    end
    
endmodule