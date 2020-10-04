`timescale 1ns/1ps

module Carry_Look_Ahead_Adder (a, b, cin, cout, light, set);
input [4-1:0] a, b;
input cin;
output cout;
output [6:0] light;
output [3:0] set;
    
    zero z1(set[3], cin);
    one o1(set[2], cin);
    one o2(set[1], cin);
    one o3(set[0], cin);
    
wire [4-1:0] sum;
wire [3:0] nsum;
wire ncout;

    nand ns [3:0] (nsum, sum, sum);
    
    wire [3:0] p, g;
    wire [3:0] c;
    
    AND and0(c[0], cin, cin);
    
    XOR xor1 [3:0] (p, a, b);
    AND and1 [3:0] (g, a, b);
    
    // c1 = p0 c0 or g0
    // c2 = p0 p1 c0 or g0 p1 or g1 
    
    wire [3:0] pc;
    AND and2(pc[0], p[0], c[0]);
    OR or1(c[1], pc[0], g[0]);
    
    AND and3(pc[1], p[1], c[1]);
    OR or2(c[2], pc[1], g[1]);
    
    AND and4(pc[2], p[2], c[2]);
    OR or3(c[3], pc[2], g[2]);
    
    AND and5(pc[3], p[3], c[3]);
    OR or4(ncout, pc[3], g[3]);
    
    adder add [3:0] (a, b, c, , sum);
    
    nand nand0(cout, ncout, ncout);
    // A
        wire [3:0] four, naf;
        
        nand nand1(four[0], nsum[3], nsum[2], nsum[1], sum[0]);
        nand nand2(four[1], nsum[3], sum[2], nsum[1], nsum[0]);
        nand nand3(four[2], sum[3], sum[2], nsum[1], sum[0]);
        nand nand4(four[3], sum[3], nsum[2], sum[1], sum[0]);
        
        nand nna(light[0], four[0], four[1], four[2], four[3]);
        
    // B
        wire [3:0] bfour, nbf;
        
        nand nand7(bfour[0], sum[1], sum[0], sum[3]);
        nand nand8(bfour[1], nsum[0], sum[1], sum[2]);
        nand nand9(bfour[2], sum[2], sum[3], nsum[0]);
        nand nand10(bfour[3], sum[0], nsum[1], sum[2], nsum[3]);
        
        nand nnb(light[1], bfour[0], bfour[1], bfour[2], bfour[3]);
        
    // C
        wire [2:0] cfour, ncf;
        
        nand nand13(cfour[0], sum[2], sum[3], sum[1]);
        nand nand14(cfour[1], sum[2], sum[3], nsum[0]);
        nand nand15(cfour[2], nsum[3], nsum[2], sum[1], nsum[0]);
        
        nand nnc(light[2], cfour[0], cfour[1], cfour[2]);
        
    // D
        wire [3:0] dfour, ndf;
        
        nand nand18(dfour[0], sum[2], sum[0], sum[1]);
        nand nand19(dfour[1], sum[1], sum[3], nsum[2], nsum[0]);
        nand nand20(dfour[2], sum[0], nsum[2], nsum[1], nsum[3]);
        nand nand21(dfour[3], sum[2], nsum[3], nsum[0], nsum[1]);
        
        nand nnd(light[3], dfour[0], dfour[1], dfour[2], dfour[3]);
        
    // E
        wire [2:0] efour, nef;
        
        nand nand24(efour[0], sum[0], nsum[3]);
        nand nand25(efour[1], nsum[1], sum[2], nsum[3]);
        nand nand26(efour[2], sum[0], nsum[1], nsum[2]);
        
        nand nnf(light[4], efour[0], efour[1], efour[2]);
    
    // F
        wire [3:0] ffour, nff;
        
        nand nand29(ffour[0], sum[0], nsum[2], nsum[3]);
        nand nand30(ffour[1], sum[0], sum[1], nsum[3]);
        nand nand31(ffour[2], sum[1], nsum[2], nsum[3]);
        nand nand32(ffour[3], sum[0], nsum[1], sum[2], sum[3]);
        
        nand nne(light[5], ffour[0], ffour[1], ffour[2], ffour[3]);
    
    // G
        wire [2:0] gfour, ngf;
        
        nand nand35(gfour[0], nsum[1], nsum[2], nsum[3]);
        nand nand36(gfour[1], sum[2], sum[3], nsum[0], nsum[1]);
        nand nand37(gfour[2], sum[1], sum[2], nsum[3], nsum[0]);
        
        nand nng(light[6], gfour[0], gfour[1], gfour[2]);
    
endmodule

module AND(c, a, b);

    input a, b;
    output c;
    
    wire mid;
    nand nand1(mid, a, b);
    nand nand2(c, mid, mid);

endmodule

module OR(c, a, b);
    
    input a, b;
    output c;
    
    wire up, down;
    
    nand nand1(up, a, a);
    nand nand2(down, b, b);
    
    nand nand3(c, up, down);
    
endmodule

module XOR(c, a, b);
    
    input a, b;
    output c;
    
    wire up, down;
    wire nota, notb;
    
    nand nand1(nota, a, a);
    nand nand2(notb, b, b);
    
    AND and1(up, a, notb);
    AND and2(down, b, nota);
    
    OR or1(c, up, down);
    
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
	
    not n1(nota,a),n2(notb,b);
    and a1(aandb,a,b),a2(notab,nota,notb);
    or o1(cout,aandb,notab);
	
endmodule

module MUX(a,b,sel,f);
    input a,b;
    input sel;
    output f;

    wire nots,mix1,mix2;

    not n1(nots,sel);
    and a1(mix1,a,sel),a2(mix2,b,nots);
    or o1(f,mix1,mix2);

endmodule

module zero(c, a);

    input a;
    output c;
    
    XOR xor1(c, a, a);
    
endmodule

module one(c, a);
    
    input a;
    output c;
    
    XNOR xnor1(a, a, c);

endmodule