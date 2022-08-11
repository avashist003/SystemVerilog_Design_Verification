//
// Synchronous memory module with dual ports
// Read and write to same address in the same cycle will result in 
// reading forwarded new value in the next clock.
//
module sync_mem_rd_fwd #(
  parameter ADDR_WIDTH = 8,
  parameter DATA_WIDTH = 8
)(
  input logic clk,
  input logic rst,
  // write port
  input logic [ADDR_WIDTH-1:0] wr_addr_in,
  input logic [DATA_WIDTH-1:0] wr_data_in,
  input logic wr_en,
  // read port
  input logic [ADDR_WIDTH-1:0] rd_addr_in,
  output logic [DATA_WIDTH-1:0] rd_data_out
);

  // declare the memory -- flip flop based
  localparam DEPTH = 1 << ADDR_WIDTH;

  logic [DATA_WIDTH-1:0] mem [DEPTH-1:0];


  always_ff@(posedge clk) begin
    if (wr_en) begin
      mem[wr_addr_in] <= wr_data_in;
    end
  end

  // forwarding if rd_addr is equal to wr_addr and wr-en is asserted
  // Use a MUX to control the forewarding
  logic [DATA_WIDTH-1:0] rd_data_tmp;

  always_ff@(posedge clk) begin
    if (rst) begin
      rd_data_tmp <= '0;
    end
    // Use an equaity comparator and and operation then use it as MUX select
    else if ((rd_addr_in == wr_addr_in) && wr_en) begin
      rd_data_tmp <= wr_data_in;
    end
    else begin
      rd_data_tmp <= mem[rd_addr_in];
    end
  end

  // assign the read output
  assign rd_data_out = rd_data_tmp;



endmodule
