module test;

  reg clk, rst_n;
  reg [1:0] x_in;
  reg start;

  wire [5:0] result_out;

  
  // blow one for the sequentail version
  x_cube_v DUT (clk, rst_n, x_in, result_out, start, finish);
  
  initial begin
    clk = 0;
    rst_n = 0;
    start = 0;
    @(negedge clk) rst_n = 1;
    x_in = 2'b10;
    start = 1;
    
    @(negedge clk) x_in = 2'b11;
    @(negedge clk);
    @(negedge clk);


    @(negedge clk); start = 0;
    # 50 $finish;
  end
  
  // 50 MHz clock
  always #20 clk = ~clk;

endmodule
