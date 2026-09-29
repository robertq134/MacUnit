module testbench;
parameter BIT_WIDTH = 8;
parameter OUTPUTBITWIDTH = BIT_WIDTH * 2;
reg clk, reset, in;
reg [BIT_WIDTH-1:0] M, Q;
wire [OUTPUTBITWIDTH-1:0] out;
wire done;

BinaryMultiplicationPartialSum #(
  .BIT_WIDTH(BIT_WIDTH), 
  .OUTPUTBITWIDTH(OUTPUTBITWIDTH)
) inst1 (
  .in(in), 
  .clk(clk), 
  .reset(reset), 
  .M(M), 
  .Q(Q), 
  .out(out), 
  .done(done)
);

// Name by instantiation .inner_module(out_module)
always #5 clk = ~clk;
initial begin
  $dumpfile("BinaryMultiplicationPartialSumTestBench.vcd");
  $dumpvars(0, testbench);
  $monitor($time,"clk=%b, reset=%b, in=%b, M=%b, Q=%b, out=%b, done=%b", clk, reset, in, M, Q, out, done);
  reset = 1; clk = 0; reset = 1; in = 0; M = 8'b00000000; Q = 8'b00000000;
  #5 reset = 0; in = 1; M = 8'b01010111; Q = 8'b01010111; //  01110110010001 (7569)
  #5 in = 1;
  #5 in = 0;
  #100 $finish;
end

endmodule