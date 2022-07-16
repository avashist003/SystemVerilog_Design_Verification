// 				Register File
// 				SPECIFICATIONS
// Two read and one write port Register File
// Parameterized for Width and Depth
// Register 0 cannot be written and is always set to 0
// Reading is combinational i.e. available in same cycle

module register_file 
  #(parameter DATA_WIDTH = 8,
    // locations = 2**DEPTH
    parameter DEPTH = 2
   ) (
    input logic clk,
    input logic rst_n,
    // read ports
    input logic [DEPTH-1:0] in_rd_addr1,
    input logic [DEPTH-1:0] in_rd_addr2,
    output logic [DATA_WIDTH-1:0] out_rd_data1,
    output logic [DATA_WIDTH-1:0] out_rd_data2,
    // write enable
    input logic  in_we,
    // write ports
    input logic [DEPTH-1:0] in_wr_addr,
    input logic [DATA_WIDTH-1:0] in_wr_data
  );

  // Registers in our register-file
  logic [DATA_WIDTH-1:0] reg_file [2**DEPTH-1:0];

  always_ff@(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      for(integer i= 0; i < 2**DEPTH; i=i+1) begin
        reg_file[i] <= '0;
      end
    end
    // Decoder logic to select the register to write the data
    else begin
      if (in_we && (in_wr_addr != '0)) begin
        reg_file[in_wr_addr] <= in_wr_data;
      end
    end
  end


  // combinational Reads, MUXs with read addr as select
  assign out_rd_data1 = (in_rd_addr1 == '0) ? '0 : reg_file[in_rd_addr1];
  assign out_rd_data2 = (in_rd_addr2 == '0) ? '0 : reg_file[in_rd_addr2];
  
  //
  //
  // --------------------- SVA ----------------------- //
  // -------------------------------------------------- //
  // 1 Localtion-1 is never writeen and always set to 0
  property first1_location_zero_P;
    @(posedge clk) disable iff (!rst_n)
    in_rd_addr1 == '0 |-> (out_rd_data1 == '0);
  endproperty
  
  property first2_location_zero_P;
    @(posedge clk) disable iff (!rst_n)
    in_rd_addr2 == '0 |-> (out_rd_data2 == '0);
  endproperty
  

  first1_location_zero_A: assert property(first1_location_zero_P)
    else $display($time, " Failed");
    
    first2_location_zero_A: assert property(first2_location_zero_P)
    else $display($time, " Failed");
  
endmodule
