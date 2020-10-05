`timescale 1ns/1ps

module Multiplier (a, b, p);
input [4-1:0] a, b;
output [8-1:0] p;

    wire [3:0] B0, B1, B2, B3;
    
    AND and1(B0, a, b[0]);
    AND and2(B1, a, b[1]);
    AND and3(B2, a, b[2]);
    AND and4(B3, a, b[3]);
    
    wire [10:0] carry;
    wire [5:0] down;
    
    wire z;
    zero z1(z, b[0]);
    
    wire mid;
    nor nor1(mid, B0[0], B0[0]);
    nor nor2(p[0], mid, z); 
    
    adder add1(B0[1], B1[0], z, carry[0], p[1]);
    
    adder add2(B0[2], B1[1], carry[0], carry[1], down[0]);
    adder add3(B2[0], down[0], z, carry[2], p[2]);
    
    adder add4(B0[3], B1[2], carry[1], carry[3], down[1]);
    adder add5(B2[1], down[1], carry[2], carry[4], down[2]);
    adder add6(B3[0], down[2], z, carry[5], p[3]);
    
    adder add7(B1[3], z, carry[3], carry[6], down[3]);
    adder add8(B2[2], down[3], carry[4], carry[7], down[4]);
    adder add9(B3[1], down[4], carry[5], carry[8], p[4]);
    
    adder add10(B2[3], carry[6], carry[7], carry[9], down[5]);
    adder add11(B3[2], down[5], carry[8], carry[10], p[5]);
    
    adder add12(B3[3], carry[9], carry[10], p[7], p[6]);

endmodule

module AND(c, a, b);

    input [3:0] a;
    input b;
    output [3:0] c;
    
    wire [3:0] up, down;
    nor nor1(up[0], a[0], a[0]);
    nor nor2(down[0], b, b);
    nor nor3(c[0], up[0], down[0]);
    nor nor4(up[1], a[1], a[1]);
    nor nor5(down[1], b, b);
    nor nor6(c[1], up[1], down[1]);
    nor nor7(up[2], a[2], a[2]);
    nor nor8(down[2], b, b);
    nor nor9(c[2], up[2], down[2]);
    nor nor10(up[3], a[3], a[3]);
    nor nor11(down[3], b, b);
    nor nor12(c[3], up[3], down[3]);

endmodule

module adder(a,b,cin,cout,sum);
    input a,b;
    input cin;
    output cout;
    output sum;

    wire q1;
    XNOR x1(a,b,q1);
    XNOR x2(q1,cin,sum);
    MUX m1(a,cin,q1,cout);

endmodule

module XNOR(a,b,cout);
    input a,b;
    output cout;
	
    wire aandb,notab,nota,notb;
	
    nor n1(nota,a,a),n2(notb,b,b);
    
    wire up, down;
    
    nor a1(aandb,nota,notb);
    nor a2(notab,a,b);
    
    wire ncout;
    nor o1(ncout,aandb,notab);
    nor o2(cout, ncout, ncout);
	
endmodule

module MUX(a,b,sel,f);
    input a,b;
    input sel;
    output f;

    wire nots,mix1,mix2;

    nor n1(nots, sel, sel);
    
    wire na, nb;
    
    nor nor1(na, a, a);
    nor nor2(nb, b, b);
    
    nor nor3(mix1, na, nots);
    nor nor4(mix2, nb, sel);
    
    wire midf;
    nor o1(midf,mix1,mix2);
    nor o2(f, midf, midf);

endmodule

module zero(out, in);

    input in;
    output out;
    
    XOR xor1(out, in, in);

endmodule

module one(out, in);

    input in;
    output out;
    
    XNOR xnor1(in, in, out);

endmodule
