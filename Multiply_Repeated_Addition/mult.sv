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
  
  
endmodule
