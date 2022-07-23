module test;
  
  logic clk;
   logic rst_n;
  //
  logic valid_in;
  logic [3:0] in_a;
  logic [3:0] in_b;
  //
  logic [3:0] y_out;
  logic valid_out, ready_out;

  

  bit_serial_adder DUT (
    clk,
    rst_n,
    //
    valid_in,
    in_a,
    in_b,
    ready_out,
    //
    y_out,
    valid_out
  );

  initial begin
    clk = 0;
    rst_n = 0;
    valid_in = 0;
    @(negedge clk) rst_n = 1;
    in_a = 4'ha; in_b = 4'h4; valid_in = 1;
    
    @(negedge clk) in_a = 4'h2; in_b = 4'h8; valid_in = 1;
    
    repeat(5) @(negedge clk);
    valid_in = 0;
    
    #20 $finish;
  end

  always #20 clk = ~clk;


endmodule
