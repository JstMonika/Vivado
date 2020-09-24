`timescale 1ns/1ps

module Mux_8bits (a, b, c, d, sel1, sel2, sel3, f);
    input [7:0] a, b, c, d;
    input sel1, sel2, sel3;
    output [7:0] f;
    
    wire [7:0] up, down;
    
    MUX_for_8bits mux1(.a(a), .b(b), .sel(sel1), .out(up));
    MUX_for_8bits mux2(.a(c), .b(d), .sel(sel2), .out(down));
    MUX_for_8bits mux3(.a(up), .b(down), .sel(sel3), .out(f));

endmodule

module MUX_for_8bits(a, b, sel, out);
    
    input [7:0] a, b;
    input sel;
    output [7:0] out;
    
    wire [7:0] aandsel, bandnsel;
    wire nsel;
    
    not not1(nsel, sel);
    
    // 0
    and and1(aandsel[0], a[0], sel);
    and and2(bandnsel[0], b[0], nsel);
    or or1(out[0], aandsel[0], bandnsel[0]);
    // 1
    and and3(aandsel[1], a[1], sel);
    and and4(bandnsel[1], b[1], nsel);
    or or2(out[1], aandsel[1], bandnsel[1]);
    // 2
    and and5(aandsel[2], a[2], sel);
    and and6(bandnsel[2], b[2], nsel);
    or or3(out[2], aandsel[2], bandnsel[2]);
    // 3
    and and7(aandsel[3], a[3], sel);
    and and8(bandnsel[3], b[3], nsel);
    or or4(out[3], aandsel[3], bandnsel[3]);
    // 4
    and and9(aandsel[4], a[4], sel);
    and and10(bandnsel[4], b[4], nsel);
    or or5(out[4], aandsel[4], bandnsel[4]);
    // 5
    and and11(aandsel[5], a[5], sel);
    and and12(bandnsel[5], b[5], nsel);
    or or6(out[5], aandsel[5], bandnsel[5]);
    // 6
    and and13(aandsel[6], a[6], sel);
    and and14(bandnsel[6], b[6], nsel);
    or or7(out[6], aandsel[6], bandnsel[6]);
    // 7
    and and15(aandsel[7], a[7], sel);
    and and16(bandnsel[7], b[7], nsel);
    or or8(out[7], aandsel[7], bandnsel[7]);
    
endmodule