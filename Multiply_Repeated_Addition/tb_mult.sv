
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

  // 50 MHz clock
  always #20 clk = ~clk;
  
  // -------- SVA ------------------//
  
  logic [7:0] ref_mult_out;
  logic [3:0] in_1, in_2;
  
  always_ff@(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      in_1 <= '0;
      in_2 <= '0;
    end
    else if (valid_in && ready_out) begin
      in_1 = in_a;
      in_2 = in_b;
    end
  end
  // reference output
  assign ref_mult_out = in_1 * in_2;
  
  property out_check_P;
    @(posedge clk) disable iff (!rst_n)
    valid_out |-> (mult_out == ref_mult_out);
  endproperty
  
  property valid_ready_in_P;
    @(posedge clk) disable iff (!rst_n)
    valid_in && !ready_out |-> ##1 valid_in && $stable(in_a) && $stable(in_b);
  endproperty
  
  assume property(valid_ready_in_P) $display($time, " PASS ready/valid");
    else $display($time, " FAILED ready/valid");
  
    assert property(out_check_P) $display($time, " PASS out check");
      else $display($time, " FAILED out check %h %h", mult_out, ref_mult_out);
  

endmodule
