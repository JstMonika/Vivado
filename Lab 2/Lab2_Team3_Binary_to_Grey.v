`timescale 1ns/1ps

module Binary_to_Grey (din, dout);
input [4-1:0] din;
output [4-1:0] dout;
    
    AND and1(dout[3], din[3], din[3]);
    XOR xor1(dout[2], din[3], din[2]);
    XOR xor2(dout[1], din[2], din[1]);
    XOR xor3(dout[0], din[1], din[0]);
    
endmodule

module AND(c, a, b);
    
    input a, b;
    output c;
    
    wire mid;
    
    nand one(mid, a, b);
    nand two(c, mid, mid);

endmodule

module NOT(b, a);

    input a;
    output b;
    
    nand out(b, a, a);
    
endmodule

module XOR(c, a, b);
    
    input a, b;
    output c;
    wire nota, notb;
    
    NOT NOT1(nota, a);
    NOT NOT2(notb, b);
    
    wire up, down;
    nand nand1(up, nota, b);
    nand nand2(down, notb, a);
    nand out(c, up, down);
    
endmodule