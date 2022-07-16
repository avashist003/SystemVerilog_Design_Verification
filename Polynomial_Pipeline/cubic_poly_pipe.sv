// Pipeline implementation //
// Polynomial: y = x^3 + k;
//
// After pipeline is full, we get result every clock cycle :-)
//


module cubic_poly_pipe (
  input logic clk,
  input logic rst_n,
  input logic [1:0] x_in,
  input logic [1:0] x_in_c,
  output logic [5:0] result_out,
  output logic start
);


  logic [1:0] x_stage_1, x_stage_2;
  logic [1:0] x_s_1_c,x_s_2_c;
  logic [5:0] x_rel_1, x_rel_2;
  
  always_ff@(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      x_stage_1 <= '0;
      x_rel_1 <= '0;
      x_s_1_c <= '0;
    end
    else if (start) begin
      x_stage_1 <= x_in;
      x_rel_1 <= x_in;
      x_s_1_c <= x_in_c;
    end
  end
  
  always_ff@(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      x_stage_2 <='0;
      x_rel_2 <= '0;
      x_s_2_c <= '0;
    end
    else begin
      x_stage_2 <= x_stage_1;
      x_rel_2 <= x_stage_1 * x_rel_1; // x*x
      x_s_2_c <= x_s_1_c;
      
    end
  end
  
  always_ff@(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      result_out <='0;
    end
    else begin
      result_out <= (x_rel_2 * x_stage_2) + x_s_2_c; // final output x^2*x + c
    end
  end
  
endmodule

