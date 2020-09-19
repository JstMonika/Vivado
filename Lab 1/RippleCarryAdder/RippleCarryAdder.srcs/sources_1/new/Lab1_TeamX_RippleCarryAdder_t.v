`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/19 16:36:48
// Design Name: 
// Module Name: t
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


module tb();
    
    reg [7:0] a, b;
    reg cin;
    wire [8:0] out;
    
    RippleCarryAdder RCA1(.a(a), .b(b), .cin(cin), .cout(out[8]), .sum(out[7:0]));
    
    initial begin
        
        a = 8'd0;
        b = 8'd0;
        cin = 1'd0;
        
        repeat (2 ** 5) begin
            #1
            
            a = a + 8'd5;
            b = b + 8'd11;
            cin = ~cin;
            
        end
    
    end
    
endmodule
