`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2020 02:56:57 PM
// Design Name: 
// Module Name: Lab3_Team3_Memory_t
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


module Lab3_Team3_Memory_t();
    
    parameter test = 20;
    
    reg clk = 0;
    always #2 clk = ~clk;
    
    reg ren, wen;
    reg [6:0] addr;
    reg [7:0] din;
    wire [7:0] dout;
    
    Memory M1(.clk(clk), .ren(ren), .wen(wen), .addr(addr), .din(din), .dout(dout));
    
    initial begin
        
        ren = 0;
        wen = 0;
        
        repeat (2 ** 6) begin
            
            @(negedge clk) begin
                {ren, wen} = $random;
                addr = {$random} % test;
                din = $random;
            end
        end
        
        addr = 0;
        
        repeat (test) begin
            
            @(negedge clk) begin
                {ren, wen} = 2'b10;
                addr = addr + 1;
            end            
        end
        
        $finish;
    end
endmodule
