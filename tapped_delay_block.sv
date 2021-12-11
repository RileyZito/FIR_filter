`timescale 1ns / 100ps
`default_nettype none

module tapped_delay_block(b, x_in, x_out, y_in, y_out, clk, ena, rst);
parameter N = 32;

input  wire  signed [N-1:0] b;
input  wire  signed [N-1:0] x_in;
input  wire  signed [N-1:0] y_in;
output logic signed [N-1:0] x_out;
output logic signed [N-1:0] y_out;
input  wire                 clk;
input  wire                 ena;
input  wire                 rst;

register #(.N(N)) REGISTER(
    .clk(clk),
    .ena(ena),
    .rst(rst),
    .d(x_in),
    .q(x_out)
);

always_comb begin : output_logic
    y_out = (x_in * b) + y_in;  // x_in changes on negedge
end

endmodule

`default_nettype wire // reengages default behaviour, needed when using 
                      // other designs that expect it.
