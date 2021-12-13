`timescale 1ns / 100ps
`default_nettype none

module tapped_delay_block(b, x_in, x_out, y_in, y_out, clk, ena, rst);
parameter N = 32;

input  wire  signed [N-1:0] b;     // coefficients
input  wire  signed [N-1:0] x_in;  // input to the delay block
input  wire  signed [N-1:0] y_in;  // signal to add to x_in after arithmetic operations
output logic signed [N-1:0] x_out; // delayed x_in 
output logic signed [N-1:0] y_out; // signal after arithmetic operations (combinationally driven)
input  wire                 clk;
input  wire                 ena;
input  wire                 rst;

async_reg #(.N(N)) REGISTER(  // Induces delay.
    .clk(clk),
    .ena(ena),
    .rst(rst),
    .d(x_in),
    .q(x_out)
);

always_comb begin : output_logic
    y_out = (x_in * b) + y_in;  // combinational logic where x_in is multiplied by coefficient and added to y_in
end

endmodule

`default_nettype wire // reengages default behaviour, needed when using 
                      // other designs that expect it.
