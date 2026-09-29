// Problem: only takes in one cycle of inputs and stops.

module BinaryMultiplicationPartialSum
#(
  parameter BIT_WIDTH = 8,
  parameter OUTPUTBITWIDTH = BIT_WIDTH  * 2
)(
  input clk,
  input in,
  input reset, // high reset
  input [BIT_WIDTH-1:0] M, Q,
  output [OUTPUTBITWIDTH-1:0] out,
  output done
);

parameter idle = 2'b00, check = 2'b01, DONE = 2'b11;
reg [BIT_WIDTH-1:0] Q_reg;
reg [BIT_WIDTH-1:0] M_reg;
reg [OUTPUTBITWIDTH-1:0] out_reg;
reg [1:0] state, next_state; 
reg [BIT_WIDTH:0] cycle_count;
reg [OUTPUTBITWIDTH-1:0] temp_out;

always @(*) begin
  case(state)
    idle: next_state = in ? check : idle;
    check: next_state = (cycle_count == BIT_WIDTH) ? DONE : check;
    DONE: next_state = idle;
    default: next_state = idle;
  endcase
end

always @(posedge clk, posedge reset) begin
  if (reset) begin  
    state <= 0; 
    Q_reg <= 0;
    M_reg <= 0;
    cycle_count <= 0;
  end
  else begin 
    state <= next_state; 
    if (state == idle && in) begin
        Q_reg <= Q;
        M_reg <= M;
        out_reg <= 0;
        cycle_count <= 0;
      end
    else if (state == check && cycle_count < BIT_WIDTH) begin
        if (Q_reg[0] == 1'b1) begin 
          temp_out = {out_reg[OUTPUTBITWIDTH-1:BIT_WIDTH] + M_reg, out_reg[BIT_WIDTH-1:0]};
        end else begin
          temp_out = out_reg;
        end
        out_reg <= temp_out >> 1;
        cycle_count <= cycle_count + 1;
        Q_reg <= Q_reg >> 1;
    end
  end
end

assign done = (state == DONE) ? 1'b1 : 1'b0;
assign out = out_reg;

endmodule