`timescale 1ns/1ps

module Decode_and_Execute (op_code, rs, rt, rd);
    input [3-1:0] op_code;
    input [4-1:0] rs, rt;
    output [4-1:0] rd;
    
    wire [3:0] u, d, uu, ud, du, dd, udu, udd, duu, dud, uuu, uud;
    
    MUX mux1 [3:0] (u, d, op_code[2], rd);
    
    MUX mux2 [3:0] (uu, ud, op_code[1], u);
    MUX mux3 [3:0] (du, dd, op_code[1], d);
    
    MUX mux4 [3:0] (udu, udd, op_code[0], ud);
    MUX mux5 [3:0] (duu, dud, op_code[0], du);
    MUX mux6 [3:0] (uuu, uud, op_code[0], uu);
    
    wire z, o;
    zero z1(z, rs[0]);
    onr o1(o, rs[0]);
    
    f_bit_adder fba1(rs, rt, dd, op_code[0]);
    f_bit_adder fba2(rs, {3{z}, o}, dud, z);
    
    nor nor1 [3:0] (duu, rs, rt);
    NAND nand1 [3:0] (udd, rs, rt);
    
    wire [7:0] result;
    
    div div1(udu, rs);
    mul mul1(uud, rs);
    Multiplier mul2(rs, rt, result);
    
    AND and1(uuu[0], result[0], result[0]);
    AND and2(uuu[1], result[1], result[1]);
    AND and3(uuu[2], result[2], result[2]);
    AND and4(uuu[3], result[3], result[3]);
    
endmodule

module div(out, in);

    input [3:0] in;
    output [3:0] out;
    
    AND and1(out[0], in[2], in[2]);
    AND and2(out[1], in[3], in[3]);
    XOR and3(out[2], in[0], in[0]);
    XOR and4(out[3], in[0], in[0]);
    
endmodule

module mul(out, in);
    
    input [3:0] in;
    output [3:0] out;
    
    XOR and1(out[0], in[0], in[0]);
    AND and2(out[1], in[0], in[0]);
    AND and3(out[2], in[1], in[1]);
    AND and4(out[3], in[2], in[2]);
    
endmodule

module NAND(c, a, b);

    input a, b;
    output c;
    
    wire up, down, mid;
    
    nor nor1(up, a, a);
    nor nor2(down, b, b);
    
    nor nor3(mid, up, down);
    nor nor4(c, mid, mid);
    
endmodule

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
    
    wire mid;
    
    wire z;
    zero z1(z, b[0]);
    
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
    nor a1(aandb,nota,notb),a2(notab,a,b);
    
    wire ncout;
    nor o1(ncout,aandb,notab);
    nor o2(cout, ncout, ncout);
	
endmodule

module XOR(c, a, b);

    input a, b;
    output c;
    
    wire mid;
    XNOR xnor1(a, b, mid);
    
    nor nor1(c, mid, mid);
    
endmodule

module MUX(a,b,sel,f);
    input a,b;
    input sel;
    output f;

    wire nots,mix1,mix2;

    nor n1(nots,sel, sel);
    
    wire na, nb;
    nor n2(na, a, a);
    nor n3(nb, b, b);
    nor a1(mix1,na,nots),a2(mix2,nb,sel);
    
    wire nf;
    nor o1(nf,mix1,mix2);
    nor o2(f, nf, nf);

endmodule

module f_bit_adder(a, b, sum, sel);

    input [3:0] a, b;
    input sel;
    output [3:0] sum;
    
    wire [2:0] c;
    wire [3:0] B;
    
    XOR xor1(B[0], sel, b[0]);
    XOR xor2(B[1], sel, b[1]);
    XOR xor3(B[2], sel, b[2]);
    XOR xor4(B[3], sel, b[3]);
    
    adder add1(a[0], B[0], sel, c[0], sum[0]);
    adder add2(a[1], B[1], c[0], c[1], sum[1]);
    adder add3(a[2], B[2], c[1], c[2], sum[2]);
    adder add4(a[3], B[3], c[2], , sum[3]);
        
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
