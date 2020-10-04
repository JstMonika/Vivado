`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2020 03:16:56 PM
// Design Name: 
// Module Name: Lab2_Team3_Carry_Look_Ahead_Adder_t
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


module Lab2_Team3_Carry_Look_Ahead_Adder_t();
    
    reg [3:0] a, b;
    reg cin;
    wire [4:0] out;
    reg [4:0] test;
    wire correct;
    
    assign correct = (test == out);
    
    Carry_Look_Ahead_Adder CLA(.a(a), .b(b), .cin(cin), .cout(out[4]), .sum(out[3:0]));
    
    initial begin
        a = 4'b0;
        b = 4'b0;
        
        repeat (2 ** 10) begin
            
            #1
            {a, b, cin} = {9{$random}};
            
            test = a + b + cin;
            
        end
        
        #1 $finish;
    end
    
    
endmodule
