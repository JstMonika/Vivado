`timescale 1ns/1ps

module Decoder (din, dout);

    input [4-1:0] din;
    output [16-1:0] dout;
    
    wire [3:0] revert;
    not not1(revert[3], din[3]);
    not not2(revert[2], din[2]);
    not not3(revert[1], din[1]);
    not not4(revert[0], din[0]);
    
    and and1(dout[15], );
    and and2();
    
    and and3();
    and and4();
    
    and and5();
    and and6();
    
    and and7();
    and and8();
    
    and and9();
    and and10();
    
    and and11();
    and and12();
    
    and and13();
    and and14();
    
    and and15();
    and and16();
    
endmodule
