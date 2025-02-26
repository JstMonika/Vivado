`timescale 1ns/1ps

`define CYC 4

module Clock_Divider_t;
reg clk = 1'b1;
reg rst_n = 1'b1;
reg [2-1:0] sel = 2'd0;
wire clk1_2;
wire clk1_4;
wire clk1_8;
wire clk1_3;
wire dclk;

Clock_Divider cd (
  .clk (clk),
  .rst_n (rst_n),
  .sel (sel),
  .clk1_2 (clk1_2),
  .clk1_4 (clk1_4),
  .clk1_8 (clk1_8),
  .clk1_3 (clk1_3),
  .dclk (dclk)
);

always #(`CYC / 2) clk = ~clk;

initial begin
  @ (negedge clk)
  rst_n = 1'b0;
  @ (negedge clk)
  rst_n = 1'b1;

  @ (negedge clk)
  repeat (2 ** 2) begin
    #(`CYC * 5) sel = sel + 1'b1;
  end
  #1 $finish;
end

endmodule
