`timescale 1ns / 100ps
`default_nettype none

module clk_divider(clk, clk_d, rst);
parameter CLK_HZ = 12_000_000;
parameter DESIRED_HZ = 48_000;

parameter CLK_COUNTER = CLK_HZ / DESIRED_HZ;

input wire rst;
input wire clk;
output logic clk_d;

logic [$clog2(CLK_COUNTER)-1:0] counter;
always_ff @( posedge clk ) begin : blockName
    if (rst) begin
        counter <= {$clog2(CLK_COUNTER){1'b0}};
        clk_d <= 0;
    end else begin
        if (counter == CLK_COUNTER) begin
            counter <= {$clog2(CLK_COUNTER){1'b0}};
            clk_d <= ~clk_d;
        end else begin
            counter <= counter + 1;
        end
    end
end

endmodule

`default_nettype wire // reengages default behaviour, needed when using 
                      // other designs that expect it.