`timescale 1ns / 100ps
`default_nettype none

module tapped_delay_block(b, x_in, x_out, y_in, y_out, clk, clk_d, ena, rst);
parameter N = 32;

input wire [N-1:0] b;

input wire [N-1:0] x_in;
input wire [N-1:0] y_in;
output logic [N-1:0] x_out;
output logic [N-1:0] y_out;

input wire clk;
input wire clk_d;
input wire ena;
input wire rst;

logic [N-1:0] x_in_ff;
always_ff @(posedge clk ) begin : rst_block
    if (rst) begin
        x_in_ff <= {N{1'b0}};
    end
end
always_ff @(posedge clk_d ) begin : delay_block
    if (ena&~rst) begin
        x_in_ff <= x_in;
    end
end

always_comb begin : output_logic
    y_out = (x_in * b) + y_in;
    x_out = x_in_ff;
end

endmodule

`default_nettype wire // reengages default behaviour, needed when using 
                      // other designs that expect it.