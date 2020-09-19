`timescale 1ns/1ps

module RippleCarryAdder (a, b, cin, cout, sum);
input [8-1:0] a, b;
input cin;
output [8-1:0] sum;
output cout;

wire cin2,cin3,cin4,cin5,cin6,cin7,cin8;

one_bit_fulladder r0(a[0],b[0],cin,cin2,sum[0]);
one_bit_fulladder r1(a[1],b[1],cin2,cin3,sum[1]);
one_bit_fulladder r2(a[2],b[2],cin3,cin4,sum[2]);
one_bit_fulladder r3(a[3],b[3],cin4,cin5,sum[3]);
one_bit_fulladder r4(a[4],b[4],cin5,cin6,sum[4]);
one_bit_fulladder r5(a[5],b[5],cin6,cin7,sum[5]);
one_bit_fulladder r6(a[6],b[6],cin7,cin8,sum[6]);
one_bit_fulladder r7(a[7],b[7],cin8,cout,sum[7]);

endmodule

module one_bit_fulladder(a,b,cin,cout,sum);
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
