//
// Sequential implementation y = x^3 //
// We get result every 3rd clock cyle
//


module seq_cube_poly (clk, rst_n, x_in, result_out, start, finish);
  input logic clk, rst_n;
  input logic [1:0] x_in;
  input logic start;
  output logic finish;
  output logic [5:0] result_out;

  logic [1:0] counter;

  assign finish = (counter == '0);

  always_ff@(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      counter <= '0;
    end
    else begin
      if (start) begin
        counter <= 2'b10;
        result_out <= x_in;
      end
      else if (!finish) begin
        counter <= counter - 1'b1;
        result_out <= x_in * result_out;
      end
    end
  end

endmodule
