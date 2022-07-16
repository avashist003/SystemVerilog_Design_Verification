//
// 4 Input Round-Robin Arbiter
//
module rr_arbiter
  (
    input logic clk,
    input logic rst,
    // first requester = req[0]
    // second requester = req[1] and so on ...
    input logic [3:0] req,
    // first grant = grant[0]
    // second grant = grant[1] and so on ...
    output logic [3:0] grant
  );

  // pointer for next request to be granted
  logic [1:0] ptr;
  logic [3:0] grant_next;

  // grant combinational logic
  always_comb begin
    grant_next = '0;
    case(ptr)
      2'b00: begin
        if (req[0]) begin
          grant_next = 4'b0001;
        end
        else if (req[1]) begin
          grant_next = 4'b0010;
        end
        else if (req[2]) begin
          grant_next = 4'b0100;
        end
        else if (req[3]) begin
          grant_next = 4'b1000;
        end
      end
      2'b01: begin
        if (req[1]) begin
          grant_next = 4'b0010;
        end
        else if (req[2]) begin
          grant_next = 4'b0100;
        end
        else if (req[3]) begin
          grant_next = 4'b1000;
        end
        else if (req[0]) begin
          grant_next = 4'b001;
        end
      end

      2'b10: begin
        if (req[2]) begin
          grant_next = 4'b0100;
        end
        else if (req[3]) begin
          grant_next = 4'b1000;
        end
        else if (req[0]) begin
          grant_next = 4'b001;
        end
        else if (req[1]) begin
          grant_next = 4'b0010;
        end
      end

      2'b11: begin
        if (req[3]) begin
          grant_next = 4'b1000;
        end
        else if (req[0]) begin
          grant_next = 4'b001;
        end
        else if (req[1]) begin
          grant_next = 4'b0010;
        end
        else if (req[2]) begin
          grant_next = 4'b0100;
        end
       
      end
      
    endcase
  end

  // register the Grant Output
  always_ff@(posedge clk) begin
    if (rst) grant <= '0;
    else grant <= grant_next;
  end

  // update pointer based on the grant received
  always_ff@(posedge clk) begin
    if (rst) begin
      ptr <= 0;
    end
    else begin
      case(grant_next)
        4'b0001: ptr <= 2'b01;
        4'b0010: ptr <= 2'b10;
        4'b0100: ptr <= 2'b11;
        4'b1000: ptr <= 2'b00;
      endcase
    end
  end

endmodule

