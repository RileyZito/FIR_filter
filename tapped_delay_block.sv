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

logic signed [N-1:0] x_in_ff;

always_ff @(posedge clk) begin : delay_block
    if (rst) begin
        x_out <= 0;
    end else begin
        if (ena) begin
            x_out <= x_in;
        end else begin
            x_out <= x_out;
        end
    end
end

always_comb begin : output_logic
    y_out = (x_in * b) + y_in;
end

endmodule

`default_nettype wire // reengages default behaviour, needed when using 
                      // other designs that expect it.