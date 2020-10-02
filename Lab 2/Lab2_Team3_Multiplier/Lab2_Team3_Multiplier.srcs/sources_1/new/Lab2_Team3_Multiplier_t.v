`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/02/2020 10:36:55 PM
// Design Name: 
// Module Name: Lab2_Team3_Multiplier_t
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


module Lab2_Team3_Multiplier_t();

    reg [3:0] a, b;
    wire [7:0] out;
    reg [7:0] test;
    wire correct;
    
    assign correct = (out == test);
    
    Multiplier M1(.a(a), .b(b), .p(out));
    
    initial begin
        a = 4'b0;
        b = 4'b0;
        
        repeat (2 ** 10) begin
            
            #1
            {a, b} = {8{$random}};
            test = a * b;
            
        end
        
        #1 $finish;
    end
    
    
endmodule
