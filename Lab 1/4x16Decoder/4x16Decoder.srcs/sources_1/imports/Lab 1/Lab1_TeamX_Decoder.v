`timescale 1ns/1ps

module Decoder (din, dout);

    input [4-1:0] din;
    output [16-1:0] dout;
    
    wire [3:0] r;
    not not1(r[3], din[3]);
    not not2(r[2], din[2]);
    not not3(r[1], din[1]);
    not not4(r[0], din[0]);
    
    wire [7:0] w;
    wire [7:0] r;
    
    and and1(w[7], r[3], din[2], din[1], din[0]);
    and and2(r[7], din[3], r[2], r[1], r[0]);
    or or1(dout[15], w[7], r[7]);
    or or1_2(dout[7], w[7], r[7]);
    
    and and3(w[6], r[3], din[2], din[1], r[0]);
    and and4(r[6], din[3], r[2], r[1], din[0]);
    or or2(dout[14], w[6], r[6]);
    or or2_2(dout[6], w[6], r[6]);
    
    and and5(w[5], r[3], din[2], r[1], din[0]);
    and and6(r[5], din[3], r[2], din[1], r[0]);
    or or3(dout[13], w[5], r[5]);
    or or3_2(dout[5], w[5], r[5]);
    
    and and7(w[4], r[3], din[2], r[1], r[0]);
    and and8(r[4], din[3], r[2], din[1], din[0]);
    or or4(dout[12], w[4], r[4]);
    or or4_2(dout[4], w[4], r[4]);
    
    and and9(w[3], r[3], r[2], din[1], din[0]);
    and and10(r[3], din[3], din[2], r[1], r[0]);
    or or5(dout[11], w[3], r[3]);
    or or5_2(dout[3], w[3], r[3]);
    
    and and11(w[2], r[3], r[2], din[1], r[0]);
    and and12(r[2], din[3], din[2], r[1], din[0]);
    or or6(dout[10], w[2], r[2]);
    or or6_2(dout[2], w[2], r[2]);
    
    and and13(w[1], r[3], r[2], r[1], din[0]);
    and and14(r[1], din[3], din[2], din[1], r[0]);
    or or7(dout[9], w[1], r[1]);
    or or7_2(dout[1], w[1], r[1]);
    
    and and15(w[0], r[3], r[2], r[1], r[0]);
    and and16(r[0], din[3], din[2], din[1], din[0]);
    or or8(dout[8], w[1], r[1]);
    or or8_2(dout[0], w[1], r[1]);
    
endmodule
