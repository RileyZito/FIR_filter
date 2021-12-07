/*
  a 2 bit adder daisy chaining 2 
  1 bit adders
*/

module adder_2(a, b, c_in, sum, c_out);

input  wire [1:0] a, b;
input wire c_in;
output logic [1:0] sum;
output logic c_out;

wire carry;

adder_1 ADDER_A(
  .a(a[0]),
  .b(b[0]),
  .c_in(c_in),
  .sum(sum[0]),
  .c_out(carry)
);

adder_1 ADDER_B(
  .a(a[1]),
  .b(b[1]),
  .c_in(carry),
  .sum(sum[1]),
  .c_out(c_out)
);


endmodule
