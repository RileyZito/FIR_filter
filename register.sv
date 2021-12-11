`default_nettype none

/*
A synchronous register (batch of flip flops) with rst > ena.
*/

module register(clk, ena, rst, d, q);
parameter N = 1;

input wire clk, ena, rst;
input wire [N-1:0] d;
output logic [N-1:0] q;

always_ff @(posedge clk) begin
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
