`timescale 1ns/1ps
`default_nettype none
module test_fir_n;

parameter CLK_HZ = 12_000_000;
parameter CLK_PERIOD_NS = (1_000_000_000/CLK_HZ); // Approximation.
parameter DESIRED_HZ = 48_000;
parameter CLK_COUNTER = CLK_HZ / DESIRED_HZ;

parameter N = 32;  // Signal wire size
parameter DELAYS = 3;  // Number of z^-1's (number of filter blocks is +1)

int errors = 0;

wire [(DELAYS + 1) * N - 1:0] b;
assign b = {{32'd1}, {32'd2}, {32'd3}, {32'd4}};

logic [N-1:0] x_in;
logic [N-1:0] y_out;
logic clk;
logic clk_d;
logic ena;
logic rst;

clk_divider #(.CLK_HZ(CLK_HZ), .DESIRED_HZ(DESIRED_HZ)) CLK_DIVIDER(
  .clk(clk),
  .clk_d(clk_d),
  .rst(rst)
);

fir_n #(.DELAYS(DELAYS), .N(N)) UUT(
  .x_in(x_in),
  .y_out(y_out),
  .b(b),
  .clk(clk),
  .clk_d(clk_d),
  .ena(ena),
  .rst(rst)
);

// task print_io;
//  $display()
// endtask

// Run our main clock.
always #(CLK_PERIOD_NS/2) clk = ~clk;

// 2) the test cases
initial begin
  $dumpfile("fir_n.vcd");
  $dumpvars(0, UUT);
    
  rst = 1;
  ena = 1;
  clk = 0;
  repeat(2) @(negedge clk);
  rst = 0;
  repeat(2) @(posedge clk);

  // Generate impulse
  x_in = 0;
  repeat(1) @(posedge clk_d);
  x_in = 32'd100;
  repeat(1) @(posedge clk_d);
  x_in = 0;
  repeat(1) @(posedge clk_d);

  // Let the response play out 
  repeat(20) @(posedge clk_d);

  $finish;
end

endmodule


`default_nettype wire // reengages default behaviour, needed when using 
                      // other designs that expect it.