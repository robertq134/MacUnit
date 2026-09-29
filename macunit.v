// For a single neuron accumulation = (w1 * input1) + (w2 * input2) + (wi * inputi) + ....
// Video watch it for a better understanding.

module macunit #(
    parameter BIT_WIDTH = 8,
    parameter OUTPUTBITWIDTH = BIT_WIDTH * 2,
    parameter N = 4, // Number of accumulations 
    parameter ACCUMULATOR_BIT_LENGTH = (2 * BIT_WIDTH + $clog2(N))
)
(
    input clk, reset, in,
    input [BIT_WIDTH-1:0] M, Q, // input features, M is input, Q is weight
    input clear,
    output reg [ACCUMULATOR_BIT_LENGTH-1:0] accumulator // accumulation for next activation input for next neuron
);
BinaryMultiplicationPartialSum #(
    .BIT_WIDTH(BIT_WIDTH)
) inst1 (
    .M(M),
    .Q(Q),
    .in(in),
    .clk(clk),
    .reset(reset),
    .out(product),
    .done(done)
);
wire [OUTPUTBITWIDTH-1:0] product; // driven by out so it acts as input. 
wire done;

always @(posedge clk, posedge reset) begin
    if (reset) begin
        accumulator <= 0;
    end else if (clear) begin
        accumulator <= 0;
    end else if (done) begin
        accumulator <= accumulator + product;
    end
end
endmodule