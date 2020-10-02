`timescale 1ns/1ps

module NAND_Implement (a, b, sel, out);
input a, b;
input [3-1:0] sel;
output out;
    
    wire ou, od, ouu, oud, odu, odd;
    wire oudu, oudd, oduu, odud, oddu, oddd;
    
    MUX MUX1(out, ou, od, sel[2]);
    MUX MUX2(ou, ouu, oud, sel[1]);
    MUX MUX3(od, odu, odd, sel[1]);
    
    nand nand1(ouu, a, b);
    MUX MUX4(oud, oudu, oudd, sel[0]);
    MUX MUX5(odu, oduu, odud, sel[0]);
    MUX MUX6(odd, oddu, oddd, sel[0]);
    
    NOT not1(oddd, a);
    NOR nor1(oddu, a, b);
    AND and1(odud, a, b);
    OR or1(oduu, a, b);
    XOR xor1(oudd, a, b);
    XNOR xnor1(oudu, a, b);
    
endmodule

module AND(c, a, b);
    
    input a, b;
    output c;
    
    wire mid;
    
    nand one(mid, a, b);
    nand two(c, mid, mid);

endmodule

module OR(c, a, b);

    input a, b;
    output c;
    
    wire up, down;
    
    nand one(up, a, a);
    nand two(down, b, b);
    
    nand out(c, up, down);

endmodule

module NOT(b, a);

    input a;
    output b;
    
    nand out(b, a, a);
    
endmodule

module NOR(c, a, b);

    input a, b;
    output c;
    
    wire mid;
    OR OR1(mid, a, b);
    nand out(c, mid, mid);
    
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

module XNOR(c, a, b);

    input a, b;
    output c;
    
    wire mid;
    XOR xor1(mid, a, b);
    NOT out(c, mid);
    
endmodule

module MUX(c, a, b, sel);

    input a, b, sel;
    output c;
    
    wire up, down, nots;
    
    NOT not1(nots, sel);
    AND and1(up, a, sel);
    AND and2(down, b, nots);
    OR out(c, up, down);
    
endmodule