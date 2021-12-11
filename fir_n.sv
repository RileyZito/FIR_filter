`timescale 1ns / 100ps
`default_nettype none

module fir_n(x_in, y_out, b, clk, clk_d, ena, rst);
parameter DELAYS = 3;  // Number of delay blocks (must be >= 2)
parameter N = 32;

input  wire  signed [N-1:0]            x_in;
output logic signed [N-1:0]            y_out;
input  wire         [(DELAYS+1)*N-1:0] b;
input  wire                            clk;
input  wire                            clk_d;
input  wire                            ena;
input  wire                            rst;

logic signed [N-1:0] x_in_sync;
always_ff @(posedge clk_d) begin
    x_in_sync <= x_in;
end

wire [DELAYS * N -1:0] x_wire;
wire [DELAYS * N -1:0] y_wire;
generate
    genvar i;
    for(i = 0; i <= DELAYS; i++) begin
        if (i == 0) begin
            tapped_delay_block #(.N(N)) TDB0(  // First delay block
                .b(b         [N-1 : 0]),
                .x_in(x_in_sync),
                .x_out(x_wire[N-1 : 0]),
                .y_in(0),
                .y_out(y_wire[N-1 : 0]),
                .clk(clk_d),
                .ena(ena),
                .rst(rst)
            );
        end else if (i == DELAYS) begin
            tapped_delay_block #(.N(N)) TDBD(  // Last delay block
                .b(b         [(DELAYS+1)*N-1  :  DELAYS*N]),
                .x_in(x_wire [ DELAYS*N -1    : (DELAYS-1)*N]),
                .y_in(y_wire [ DELAYS*N -1    : (DELAYS-1)*N]),
                .y_out(y_out),
                .clk(clk_d),
                .ena(ena),
                .rst(rst)
            );
        end else begin
            tapped_delay_block #(.N(N)) TDBI(  // ith delay block
                .b(b         [(i+1)*N-1 :  i*N]),
                .x_in(x_wire [ i*N-1    : (i-1)*N]),
                .x_out(x_wire[(i+1)*N-1 :  i*N]),
                .y_in(y_wire [ i*N -1   : (i-1)*N]),
                .y_out(y_wire[(i+1)*N-1 :  i*N]),
                .clk(clk_d),
                .ena(ena),
                .rst(rst)
            );
        end
    end
endgenerate

task print_io();
    $display("%d,%d", x_in, y_out);
endtask

endmodule

`default_nettype wire // reengages default behaviour, needed when using 
                      // other designs that expect it.