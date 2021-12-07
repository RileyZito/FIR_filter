/*
  a 1 bit addder that we can daisy chain for 
  ripple carry adders
*/

module adder_1(a, b, c_in, sum, c_out);

input wire a, b, c_in;
output logic sum, c_out;

always_comb begin : adder_gates
  // Setting outputs to x is a great way to debug unimplemented logic (it shows up red in gtkwave).
  c_out = 1'bx;
  sum = 1'bx;
end

endmodule
