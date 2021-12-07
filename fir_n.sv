`timescale 1ns / 100ps
`default_nettype none

module fir_n(x_in, y_out, b, clk, clk_d, ena, rst);
parameter DELAYS = 3;
parameter N = 32;

input wire [(DELAYS + 1) * N - 1:0] b;
input wire [N-1:0] x_in;
output logic [N-1:0] y_out;

input wire clk;
input wire clk_d;
input wire ena;
input wire rst;

wire [DELAYS * N -1:0] x_wire;
wire [DELAYS * N -1:0] y_wire;
generate
    genvar i;
    for(i = 0; i <= DELAYS; i++) begin
        if (i == 0) begin
            tapped_delay_block #(.N(N)) TDB0(
                .b(b         [N-1 : 0]),
                .x_in(x_in),
                .x_out(x_wire[N-1 : 0]),
                .y_in(0),
                .y_out(y_wire[N-1 : 0]),
                .clk(clk_d),
                .ena(ena),
                .rst(rst)
            );
        end else if (i == DELAYS) begin
            tapped_delay_block #(.N(N)) TDBD(
                .b(b         [(DELAYS+1)*N-1  :  DELAYS*N]),
                .x_in(x_wire [ DELAYS*N -1    : (DELAYS-1)*N]),
                .y_in(y_wire [ DELAYS*N -1    : (DELAYS-1)*N]),
                .y_out(y_out),
                .clk(clk_d),
                .ena(ena),
                .rst(rst)
            );
        end else begin
            tapped_delay_block #(.N(N)) TDBI(
                .b(b         [(i+1)*N-1 : i*N]),
                .x_in(x_wire [i*N-1     : (i-1)*N]),
                .x_out(x_wire[(i+1)*N-1 : i*N]),
                .y_in(y_wire [i*N -1    : (i-1)*N]),
                .y_out(y_wire[(i+1)*N-1 : i*N]),
                .clk(clk_d),
                .ena(ena),
                .rst(rst)
            );
        end
    end
endgenerate

endmodule

`default_nettype wire // reengages default behaviour, needed when using 
                      // other designs that expect it.