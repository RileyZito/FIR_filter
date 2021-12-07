module multiplier(clk, rst, ready_i, valid_i, ready_o, valid_o, a, b, product);

/* NOTE - this is an unsigned multiplier!!! Signed Multipliers require a little more logic to get the signs right. */

parameter N = 8;
input wire clk, rst;
input wire valid_i;
output logic ready_i;
output logic valid_o;
input wire ready_o;

input wire [N-1:0] a, b;
output logic [2*N-1:0] product;

typedef enum logic [1:0] {IDLE, COMPUTING, DONE, ERROR} state_t;
state_t state, next_state;

logic [N-1:0] counter;
logic compute_done, early_exit;

always_comb begin : output_comb_logic
  ready_i = (state == IDLE);
end

always_comb begin: compute_done_logic
  early_exit = valid_i & ( (a == 0)/* | (b == 0) */);
  compute_done = ~(counter < (b-1)) | early_exit;
end


always_ff @(posedge clk) begin : fsm_logic
  if(rst) begin
    state <= IDLE;
    counter <= 0;
    valid_o <= 0;
    product <= 0;
  end
  else begin
    case (state)
      IDLE: begin
        if(valid_i) begin
          counter <= 0;
          if(early_exit) begin // check for a or b being zero for early exit
            product <= 0;
            valid_o <= 1;
            if(ready_o) state <= IDLE;
            else state <= DONE;
          end
          else begin
            product <= 0;
            valid_o <= 0;
            state <= COMPUTING;
          end
        end
      end
      COMPUTING: begin
        product <= product + a;
        counter <= counter + 1;
        if(compute_done) begin
          valid_o <= 1;
          if(ready_o) state <= IDLE;
          else state <= DONE;
        end
      end
      DONE : begin
        if(ready_o) state <= IDLE;
      end
      default state <= ERROR;
    endcase
  end

end

endmodule