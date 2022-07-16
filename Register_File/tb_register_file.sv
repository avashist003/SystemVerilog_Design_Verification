//
// Simple Test Bench for Register File
// Showing usage of systemverilog tasks in test-benches
//
// write_file is a task that writes to the register file
// read_data is a task that reads from the register file
//
module tb_reg_file;

  parameter DEPTH = 3;
  parameter DATA_WIDTH = 8;


  logic clk, rst_n;
  logic in_we;
  logic [DEPTH-1:0] in_wr_addr;
  logic [DATA_WIDTH-1:0] in_wr_data;

  logic [DEPTH-1:0] in_rd_addr1, in_rd_addr2;
  logic [DATA_WIDTH-1:0] out_rd_data1, out_rd_data2;

  // Instantiate the DUT //
  register_file #(DATA_WIDTH, DEPTH) DUT 
                                    (clk, rst_n, in_rd_addr1, in_rd_addr2, out_rd_data1,
                                     out_rd_data2, in_we, in_wr_addr, in_wr_data);

  logic [DATA_WIDTH-1:0] write_data_TB [2**DEPTH-1:0];

  // Write data task
  task write_file;
    for(int i = 0; i < 2**DEPTH; i=i+1) begin
      @(negedge clk);
      in_we = 1;
      in_wr_addr = i;
      in_wr_data = $random;
      @(posedge clk) write_data_TB[i] = in_wr_data;
    end
  endtask

  // Read Data task with quick assertion checks
  task read_data;
    for(int i = 0; i < 2**DEPTH; i=i+1) begin
      @(negedge clk);
      in_rd_addr1 = i;
      in_rd_addr2 = i;
      @(posedge clk);
      if (i != 0) begin
        assert(out_rd_data2 == write_data_TB[i]);
        assert(out_rd_data2 == write_data_TB[i]);
      end
      else if (i == 0) begin
        assert(out_rd_data2 == '0);
        assert(out_rd_data2 == '0);
      end

      $display("rd addr %h, rd data %h",in_rd_addr1, out_rd_data1 );
      $display("rd addr %h, rd data %h",in_rd_addr2, out_rd_data2 );
    end
  endtask
  
  initial begin
    clk = 0;
    rst_n = 0;
    in_rd_addr1 = '0;
    in_rd_addr2 = '0;
    @(negedge clk) rst_n = 1;
    write_file;
    @(negedge clk) in_we = 0;
    for(int i = 0; i < 2**DEPTH; i++) begin
      $display("reg file %0h ", write_data_TB[i]);
    end
    // read task
    read_data;
    #10 $finish;
  end

  // 50 MHz clock
  always #20 clk = ~clk;

endmodule
