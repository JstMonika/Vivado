`timescale 1ns/1ps

`define CYC 4

module Mealy_t;
reg clk = 1'b1;
reg rst_n = 1'b1;
reg in = 1'b0;
wire out;
wire [3-1:0] state;

Mealy m (
  .clk (clk),
  .rst_n (rst_n),
  .in (in),
  .out (out),
  .state (state)
);

always #(`CYC / 2) clk = ~clk;

initial begin
  @ (negedge clk) rst_n = 1'b0;
  @ (posedge clk) // reset to S0
  @ (negedge clk) rst_n = 1'b1;
  @ (posedge clk) // S0 -0-> S0
  @ (negedge clk) in = 1'b1;
  @ (posedge clk) // S0 -1-> S2
  @ (negedge clk) in = 1'b0;
  @ (posedge clk) // S2 -0-> S5
  @ (negedge clk) in = 1'b1;
  @ (posedge clk) // S5 -1-> S4
  @ (posedge clk) // S4 -1-> S4
  @ (negedge clk) in = 1'b0;
  @ (posedge clk) // S4 -1-> S2
  @ (posedge clk) // S2 -0-> S5
  @ (negedge clk) in = 1'b0;
  @ (posedge clk) // S5-0->S3
  @ (posedge clk) // S3-0->S3
  @ (negedge clk) in = 1'b1;
  @ (posedge clk) // S3-1->S2
  @ (posedge clk) // S2-1->S1
  @ (negedge clk) $finish;
end

endmodule