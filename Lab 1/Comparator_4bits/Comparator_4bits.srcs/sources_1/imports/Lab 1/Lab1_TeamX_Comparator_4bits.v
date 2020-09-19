`timescale 1ns/1ps

module Comparator_4bits (a, b, a_lt_b, a_gt_b, a_eq_b);

    input [4-1:0] a, b;
    output a_lt_b, a_gt_b, a_eq_b;
    
    wire [3:0] eq;
    wire [3:0] rv_b;
    
    not not1(rv_b[3], b[3]);
    not not2(rv_b[2], b[2]);
    not not3(rv_b[1], b[1]);
    not not4(rv_b[0], b[0]);
    
    XNOR xnor1(eq[3], a[3], b[3]);
    XNOR xnor2(eq[2], a[2], b[2]);
    XNOR xnor3(eq[1], a[1], b[1]);
    XNOR xnor4(eq[0], a[0], b[0]);
    
    and equal(a_eq_b, eq[0], eq[1], eq[2], eq[3]);
    
    wire [2:0] greater;
    wire [3:0] big;
    
    and and1(big[3], rv_b[3], a[3]);
    and and2(big[2], rv_b[2], a[2]);
    and and3(big[1], rv_b[1], a[1]);
    and and4(big[0], rv_b[0], a[0]);
    
    and and6(greater[2], eq[3], big[2]);
    and and7(greater[1], eq[3], eq[2], big[1]);
    and and8(greater[0], eq[3], eq[2], eq[1], big[0]);
    
    or or1(a_gt_b, big[3], greater[2], greater[1], greater[0]);
    nor nor1(a_lt_b, a_gt_b, a_eq_b);
    
endmodule

module XNOR(out, a, b);

    input a, b;
    output out;
    
    wire nota, notb;
    not not1(nota, a);
    not not2(notb, b);
    
    wire yes, no;
    and and1(yes, a, b);
    and and2(no, nota, notb);
    
    or res(out, yes, no);
    
endmodule