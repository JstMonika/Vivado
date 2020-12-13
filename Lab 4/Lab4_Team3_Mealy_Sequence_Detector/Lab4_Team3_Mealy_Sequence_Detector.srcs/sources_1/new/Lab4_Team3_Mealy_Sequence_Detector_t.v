`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/09/2020 02:54:56 AM
// Design Name: 
// Module Name: Lab4_Team3_Mealy_Sequence_Detector_t
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


module Lab4_Team3_Mealy_Sequence_Detector_t();
    reg clk;
    reg in, rst_n;
    wire out;
    
    Mealy_Sequence_Detector M1(.clk(clk), .rst_n(rst_n), .in(in), .dec(out));
    
    always #1 clk = ~clk;
    initial begin
        clk = 0;
        rst_n = 0;
        in = 0;
        
        #5
        @(negedge clk)
        @(negedge clk) rst_n = 1;
        
        repeat (2**10) begin
            @(negedge clk)
                in = $random;
        end
    end
endmodule
