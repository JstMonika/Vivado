`timescale 1ns/1ps

module LFSR (clk, rst_n, out);
input clk, rst_n;
output out;
reg [4:0] dff;

wire b4xorb1 = dff[4] ^ dff[1];

assign out = dff[4];

always @ (posedge clk)begin
    
    if(rst_n === 0)begin
        dff <= 5'b11111;
    end
    else begin
        dff[4:0] = {dff[3:0], b4xorb1};
    end
end

endmodule