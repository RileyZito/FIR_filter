/*
A synchronous register (batch of flip flops) with rst > ena.

Code attribution: modified from https://github.com/avinash-nonholonomy/olin-cafe-f21/blob/main/examples/register.sv
*/

`default_nettype none

module async_reg(clk, ena, rst, d, q);
parameter N = 1;

input wire clk, ena, rst;
input wire [N-1:0] d;
output logic [N-1:0] q;

always_ff @(posedge clk, posedge rst) begin
  if (rst) begin
    q <= 0;
  end
  else begin
    if (ena) begin
      q <= d;
    end
  end
end

endmodule
