`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2020 02:04:33 PM
// Design Name: 
// Module Name: Lab1_TeamX_Mux_8bits_t
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

    reg [7:0] a, b, c, d;
    wire [7:0] out;
    reg [2:0] sel;
    
    initial begin
        a = 8'b00000000;
        b = 8'b00001111;
        c = 8'b11110000;
        d = 8'b11111111;
        sel = 3'b000;
    end
    
    Mux_8bits mod1(
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .sel1(sel[2]),
        .sel2(sel[1]),
        .sel3(sel[0]),
        .f(out)
    );
    
    initial begin
        #1
        repeat (2 ** 3) begin
            
            #1 sel = sel + 1'b1;
            
        end
        
        #1 $finish;
    end
    
endmodule
