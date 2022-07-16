
module test;

  logic clk;
  logic rst_n;
  logic [3:0] in_a;
  logic [3:0] in_b;
  logic valid_in;
  logic ready_out;
  //
  logic [7:0] mult_out;
  logic valid_out;


  multiplication_algo DUT (clk, rst_n, in_a, in_b,
                           valid_in, ready_out,
                           mult_out, valid_out);

  initial begin 
    clk = 0;
    rst_n = 0;
    valid_in = 0;
    in_a = 0;
    in_b = 0;
    @(negedge clk) rst_n = 1;

    @(negedge clk) in_a = 4'h5; in_b = 4'h2; valid_in = 1;
    @(negedge clk) in_a = 4'h2; in_b = 4'hf; valid_in = 1;
    
    repeat(3) @(negedge clk);
    valid_in = 0;

    #50 $finish;

  end

  always #1 clk = ~clk;
  

endmodule
