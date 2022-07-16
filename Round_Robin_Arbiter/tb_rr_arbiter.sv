module test;

  logic clk;
  logic rst;
  logic [3:0] req;
  logic [3:0] grant;


  rr_arbiter DUT (clk, rst, req, grant);
  
  initial begin
    rst = 1;
    clk = 0;
    req = 4'b0000;
    @(negedge clk) rst = 0;
    
    // x req, o/p: x
    @(negedge clk) req = 4'b0001;
    // y req, o/p: y
    @(negedge clk) req = 4'b0010;
    // x req, o/p: x
    @(negedge clk) req = 4'b1000;
    // req x & y, o/p: y
    @(negedge clk) req = 4'b1011;
    
    // req x & y, o/p: x
    //@(negedge clk) req = 4'b0011;
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    @(negedge clk) rst = 1;
    
    
    #20 $finish;
  end
  
  // 50 MHz clock
  always #20 clk = ~clk;


endmodule
