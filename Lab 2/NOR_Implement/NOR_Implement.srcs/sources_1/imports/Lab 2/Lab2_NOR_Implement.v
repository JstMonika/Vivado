`timescale 1ns/1ps

module NOR_Implement (a, b, sel, out);
input a, b;
input [3-1:0] sel;
output out;
    
    wire ou, od, ouu, oud, odu, odd;
    wire oudu, oudd, oduu, odud, oddu, oddd;
    
    MUX MUX1(out, ou, od, sel[2]);
    MUX MUX2(ou, ouu, oud, sel[1]);
    MUX MUX3(od, odu, odd, sel[1]);
    
    NAND nand1(ouu, a, b);
    MUX MUX4(oud, oudu, oudd, sel[0]);
    MUX MUX5(odu, oduu, odud, sel[0]);
    MUX MUX6(odd, oddu, oddd, sel[0]);
    
    NOT not1(oddd, a);
    nor nor1(oddu, a, b);
    AND and1(odud, a, b);
    OR or1(oduu, a, b);
    XOR xor1(oudd, a, b);
    XNOR xnor1(oudu, a, b);
    
endmodule

module NOT(b, a);

    input a;
    output b;
    
    nor out(b, a, a);
    
endmodule

module AND(c, a, b);

    input a, b;
    output c;
    
    wire up, down;
    
    nor nor1(up, a, a);
    nor nor2(down, b, b);
    
    nor out(c, up, down);
    
endmodule

module OR(c, a, b);

    input a, b;
    output c;
    
    wire mid;
    nor nor1(mid, a, b);
    nor nor2(c, mid, mid);
    
endmodule

module XOR(c, a, b);

    input a, b;
    output c;
    
    wire nota, notb;
    NOT not1(nota, a);
    NOT not2(notb, b);
    
    wire up, down;
    nor nor1(up, a, b);
    nor nor2(down, nota, notb);
    
    nor nor3(c, up, down);

endmodule

module XNOR(c, a, b);

    input a, b;
    output c;
    
    wire mid;
    
    XOR xor1(mid, a, b);
    NOT not1(c, mid);
    
endmodule

module NAND(c, a, b);

    input a, b;
    output c;
    
    wire mid;
    AND and1(mid, a, b);
    
    NOT not1(c, mid);
    
endmodule

module MUX(c, a, b, sel);

    input a, b, sel;
    output c;
    
    wire up, down, nsel;
    
    NOT not1(nsel, sel);
    AND and1(up, a, sel);
    AND and2(down, b, nsel);
    
    OR or1(c, up, down);
    
endmodule