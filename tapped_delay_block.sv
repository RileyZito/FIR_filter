`timescale 1ns / 100ps
`default_nettype none

module tapped_delay_block(b, x_in, x_out, y_in, y_out, clk, ena, rst);
parameter N = 32;

    input  wire  signed [N-1:0] b; //co-efficients
    input  wire  signed [N-1:0] x_in; //input to the delay block, recieves impulse from previous block
    input  wire  signed [N-1:0] y_in; //combinational output from previous delay block to be added
    output logic signed [N-1:0] x_out; //delayed x_in impulse
    output logic signed [N-1:0] y_out; //output of the system, shows impulse response
input  wire                 clk; //driving clock that will recieve delayed clock from fir_n
input  wire                 ena;
input  wire                 rst;

    async_reg #(.N(N)) REGISTER( //
    .clk(clk),
    .ena(ena),
    .rst(rst),
    .d(x_in), // x_in changes on negedge
    .q(x_out)
);

always_comb begin : output_logic
    y_out = (x_in * b) + y_in;  //combinational logic where x_in impulse is multiplied by co-efficients and added to previous y_out
end

endmodule

`default_nettype wire // reengages default behaviour, needed when using 
                      // other designs that expect it.
