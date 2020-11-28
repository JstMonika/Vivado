/*
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
*/
`timescale 1ns/1ps

module Sliding_Window_Detector (clk, rst_n, in, dec1, dec2);
input clk, rst_n;
input in;
output reg dec1, dec2;

reg a1,a2;

reg [2:0] d1_state,d1_nstate,d2_state,d2_nstate;

parameter IDLE = 3'b110;
parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;


always @ (posedge clk)begin
	if(!rst_n)begin
		d1_state <= IDLE;
		d1_state <= IDLE;
	end
	else begin
		d1_state <= d1_nstate;
		d2_state <= d2_nstate;
	end
end

always @ (*)begin
	case(d1_state)
		S0:begin  //
			dec1 = 0;
			if(in)
				d1_nstate = S1;
			else
				d1_nstate = S0;
		end
		S1:begin
			dec1 = 0;
			if(in)
				d1_nstate = S3;
			else
				d1_nstate = S2;
		end
		S2:begin
			if(in)begin 
				d1_nstate = S1;
				dec1 = 1;
			end
			else begin
				d1_nstate = S0;
				dec1 = 0;
			end
		end
		S3:begin
			dec1 = 0;
			if(in)
				d1_nstate = S4;
			else
				d1_nstate = S2;
		end
		S4:begin
			dec1 = 0;
			if(in)
				d1_nstate = S5;
			else
				d1_nstate = S2;
		end
		S5:begin
			dec1 = 0;
			d1_nstate = S5;
		end
		default:begin
			dec1 = 0;
			if(in)
				d1_nstate = S1;
			else
				d1_nstate = S0;
		end
	endcase

	case(d2_state)
		S0:begin
			dec2 = 0;
			if(in)
				d2_nstate = S1;
			else
				d2_nstate = S0;
		end
		S1:begin
			dec2 = 0;
			if(in)
				d2_nstate = S2;
			else
				d2_nstate = S0;
		end
		S2:begin
			dec2 = 0;
			if(in)
				d2_nstate = S2;
			else
				d2_nstate = S3;
		end
		S3:begin
			if(in)begin 
				d2_nstate = S1;
				dec2 = 1;
			end
			else begin
				d2_nstate = S0;
				dec2 = 0;
			end
		end
		default:begin
		      dec2 = 0;
			if(in)
				d2_nstate = S1;
			else
				d2_nstate = S0;
		end
	endcase
		
end

endmodule
