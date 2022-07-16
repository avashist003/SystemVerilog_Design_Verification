module test;

  logic clk, rst_n;
  logic [1:0] x_in;
  logic start;
  logic [1:0] x_in_c;

  logic [5:0] result_out;

  
  
  cubic_poly_pipe DUT (clk, rst_n, x_in, x_in_c, result_out, start);
  
  
  initial begin
    clk = 0;
    rst_n = 0;
    start = 0;
    @(negedge clk) rst_n = 1;
    x_in = 2'b10;
    x_in_c = 2'b01;
    start = 1;
    @(negedge clk) x_in = 2'b11;
    @(negedge clk) start = 0;
    # 10 $finish;
  end
  
  // 50 MHz clock
  always #20 clk = ~clk;

endmodule
