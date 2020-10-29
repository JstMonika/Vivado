`timescale 1ns/1ps

module Memory (clk, ren, wen, addr, din, dout);
input clk;
input ren, wen;
input [7-1:0] addr;
input [8-1:0] din;
output reg [8-1:0] dout;

reg [7:0] mem [127:0];

always @ (posedge clk)begin //read
    
    if(ren)begin
        dout <= mem[addr];
    end
    else begin
        dout <= 0;
    end
    
    if(wen)begin
        if (!ren) begin
            mem[addr] <= din;
        end
        else begin
            mem[addr] <= mem[addr];
        end
    end
    else begin
        mem[addr] <= mem[addr];
    end
end

endmodule