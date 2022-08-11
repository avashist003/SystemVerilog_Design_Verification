module test;

  parameter ADDR_WIDTH = 4;
  parameter DATA_WIDTH = 8;

  logic clk;
  logic rst;
  logic [ADDR_WIDTH-1:0] wr_addr_in;
  logic [DATA_WIDTH-1:0] wr_data_in;
  logic wr_en;
  logic [ADDR_WIDTH-1:0] rd_addr_in;
  logic [DATA_WIDTH-1:0] rd_data_out;



  sync_mem_rd_fwd #(ADDR_WIDTH, DATA_WIDTH) DUT (
    clk, rst, wr_addr_in, wr_data_in, wr_en,
    rd_addr_in, rd_data_out);

  initial begin
    clk = 0;
    rst = 1;
    wr_en = 0;
    @(negedge clk) rst = 0;
    // write
    wr_en = 1; wr_addr_in = 4'ha; wr_data_in = 8'haa;
    //
    @(negedge clk) wr_en = 1; wr_addr_in = 4'h0; wr_data_in = 8'hcc;
    //
    @(negedge clk) wr_en = 0; rd_addr_in = 4'h0;
    //
    @(negedge clk) wr_en = 1; wr_addr_in = 4'h5; wr_data_in = 8'h11;
    //
    @(negedge clk) wr_en = 0; rd_addr_in = 4'ha;
    
    // Read and write to same location will give
    // new value for read output at the next clock
    @(negedge clk)
    wr_en = 1; wr_addr_in = 4'h5; wr_data_in = 8'hff;
    rd_addr_in = 4'h5;
    


    #100 $finish;
  end

  // clock generator
  always #25 clk = ~clk;

endmodule
