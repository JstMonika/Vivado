`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2020 04:56:35 PM
// Design Name: 
// Module Name: Lab2_Team3_Decode_and_Execute_t
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


module Lab2_Team3_Decode_and_Execute_t();

    reg [3:0] a, b;
    reg [2:0] sel;
    wire [3:0] out;
    reg [3:0] test;
    
    wire correct = (test == out);
    
    Decode_and_Execute DaE(sel, a, b, out);
    
    initial begin
        
        a = 4'b0;
        b = 4'b0;
        sel = 3'b0;
        
        repeat (2 ** 8) begin
            
            #1 {a, b} = {8{$random}};
            
            sel = sel + 3'b1;
            
        end
        
        #1 $finish;
    end
    
    always @(sel) begin
        
        case (sel) 
                
                3'b000 : test = a + b;
                3'b001 : test = a - b;
                3'b010 : test = a + 3'b1;
                3'b011 : test = ~(a | b);
                3'b100 : test = ~(a & b);
                3'b101 : test = a >> 2;
                3'b110 : test = a << 1;
                3'b111 : test = a * b;
                
        endcase
        
    end
endmodule
