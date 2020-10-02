`timescale 1ns/1ps

module Flip_Flop (clk, d, q);
input clk;
input d;
output q;

    wire mid;
    
Latch Master (
  .clk (clk),
  .d (d),
  .q (mid)
);
    wire notclk;
    not not1(notclk, clk);
    
Latch Slave (
  .clk (notclk),
  .d (mid),
  .q (q)
);
endmodule

module Latch (clk, d, q);
input clk;
input d;
output q;

    wire notd;
    not not1(notd, d);
    
    wire up, down, notq;
    
    nand nand1(up, d, clk);
    nand nand2(down, notd, clk);
    
    nand nand3(q, up, notq);
    nand nand4(notq, down, q);

endmodule
