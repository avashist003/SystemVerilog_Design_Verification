//
// Bit Serial Sequential Adder
// Tradeoff Area for Time
//
module bit_serial_adder (
  input logic clk,
  input logic rst_n,
  //
  input logic valid_in,
  input logic [3:0] in_a,
  input logic [3:0] in_b,
  output logic ready_out,
  //
  output logic [3:0] y_out,
  output logic valid_out
);
  
  logic [3:0] reg_a, reg_b;
  logic c_out;
  
  logic s_out;
  logic c_reg;
  
  logic [2:0] count;
  
  always_ff@(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      reg_a <= '0;
      reg_b <= '0;
      c_reg <= 0;
      count <= '0;
      ready_out <= 1;
      valid_out <= 0;
    end
    else if (valid_in && ready_out) begin
      reg_a <= in_a;
      reg_b <= in_b;
      count <= count + 1;
      ready_out <= 0;
      valid_out <= 0;
    end
    else if (count >= 3'b001) begin
      reg_a <= {s_out, reg_a[3:1]} ;
      reg_b <= reg_b >> 1;
      c_reg <= c_out;
      count <= count + 1;
      if (count == 3'b100) begin
        ready_out <= 1;
        valid_out <= 1;
        count <= '0;
      end
    end
  end
  
  assign y_out = reg_a;
  
  assign {c_out, s_out} = reg_a[0] + reg_b[0] + c_reg; 
  
  
  //
  // ------------------ SVA -------------
  //
  
  // 1
  property ready_valid_in_P;
    @(posedge clk) disable iff (!rst_n)
    valid_in && !ready_out |-> ##1 valid_in && $stable(in_a) && $stable(in_b);
  endproperty
  
  // 2
  logic [3:0] in_1, in_2;
  logic [3:0] sum_out;
  always_ff@(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      in_1 <= '0;
      in_2 <= '0;
    end
    else if (valid_in && ready_out) begin
      in_1 <= in_a;
      in_2 <= in_b;
    end
  end
  
  assign sum_out = in_1 + in_2;
  
  property out_check_P;
    @(posedge clk) disable iff (!rst_n)
    valid_out |-> (y_out == sum_out);
  endproperty
  
  
  // assert the properties
  
  assume property(ready_valid_in_P) $display($time, " PASS-1");
    else $display($time, " FAILED-1");
  
    assert property(out_check_P) $display($time, " PASS-2");
      else $display($time, " FAILED-2");
  
  
  
  
endmodule
