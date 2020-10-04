`timescale 1ns/1ps

module Carry_Look_Ahead_Adder (a, b, cin, cout, light);
input [4-1:0] a, b;
input cin;
output cout;
output [6:0] light;

wire [4-1:0] sum;
wire [3:0] nsum;

    nand ns [3:0] (nsum, sum, sum);
    
    wire [3:0] p, g;
    wire [3:0] c;
    
    AND and0(c[0], 1'b1, cin);
    
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
    OR or4(cout, pc[3], g[3]);
    
    adder add [3:0] (a, b, c, , sum);
    
    
    // A
        wire [3:0] four, nf;
        
        nand nand1(four[0], nsum[3], nsum[2], nsum[1], sum[0]);
        nand nand2(four[1], nsum[3], sum[2], nsum[1], nsum[0]);
        nand nand3(four[2], sum[3], sum[2], nsum[1], sum[0]);
        nand nand4(four[3], sum[3], nsum[2], sum[1], sum[0]);
        
        nand nand5 [3:0] (nf, four, four);
        
        nand nand6(light[0], nf[0], nf[1], nf[2], nf[3]);
        
    // B
        wire [3:0] bfour, nbf;
        
        nand nand7(bfour[0], sum[1], sum[0], sum[3]);
        nand nand8(bfour[1], nsum[0], sum[1], sum[2]);
        nand nand9(bfour[2], sum[2], sum[3], nsum[0]);
        nand nand10(bfour[3], sum[0], nsum[1], sum[2], nsum[3]);
        
        nand nand11 [3:0] (nbf, bfour, bfour);
        
        nand nand12(light[1], nbf[0], nbf[1], nbf[2], nbf[3]);
        
    // C
        wire [2:0] cfour, ncf;
        
        nand nand13(cfour[0], sum[2], sum[3], sum[1]);
        nand nand14(cfour[1])
    
    // D
    
    // E
    
    // F
    
    // G
    
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