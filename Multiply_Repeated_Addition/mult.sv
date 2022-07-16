//
// Multiplication using repeated addition 
// y = a*b = a + a + ... + a (i.e. b times)
//


module multiplication_algo (
  input logic clk,
  input logic rst_n,
  input logic [3:0] in_a,
  input logic [3:0] in_b,
  input logic valid_in,
  output logic ready_out,
  //
  output logic [7:0] mult_out,
  output logic valid_out
);
  
  logic [3:0] reg_a, reg_b;
  logic [7:0] product_tmp;
  
  always_ff@(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      product_tmp <= '0;
      valid_out <= 0;
      ready_out <= 1;
    end
    else if (valid_in && ready_out) begin
      reg_a <= in_a;
      reg_b <= in_b;
      valid_out <= 0;
      product_tmp <= '0;
      ready_out <= 0;
    end
    else if (reg_b != 0) begin
      reg_b <= reg_b -1 ;
      product_tmp <= product_tmp + reg_a;
      if(reg_b == 1) begin 
        valid_out <= 1;
        ready_out <= 1;
      end
    end
  end

  assign mult_out = product_tmp;
  
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
