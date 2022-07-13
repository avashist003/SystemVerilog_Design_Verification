module formal_properties (
	input logic clk,
	input logic rst,
	// Input interface
	input logic valid_in,
	input logic ready_out,
	//
	input logic [3:0] counter_out
	);


	initial begin
		assume(rst);
		assume (!valid_in);
	end

	logic past_check;
	initial past_check = 0;
	always_ff@(posedge clk) begin
		past_check <= 1;
		if (!past_check) assume(rst);
	end

	// // deassert the reset
	// always_ff@(posedge clk) begin
	// 	if (past_check) assume(!rst);
	// end 

	// reset assertion on output
	// rst |-> ##1 (ready_out==1) && (counter_out == '0);
	always_ff@(posedge clk) begin
		if (past_check && $past(rst)) begin 
			assert(ready_out);
			assert(counter_out == '0);
		end  
	end

	// --------- Input interrface -------------//
	// assume: valid_in && !ready_out |-> ##1 valid_in;
	always_ff@(posedge clk) begin
		if (past_check && !rst && $past(valid_in) && $past(!ready_out)) begin 
			assume(valid_in);
		end  
	end

	// assert valid_in && !ready_out |-> ##[1:10] ready_out;
	logic [3:0] req_delay;
	initial req_delay = '0;
	always_ff@(posedge clk) begin
		if (rst) req_delay <= '0;

		else if ((valid_in) && (ready_out)) begin 
			req_delay <= '0;
		end 

		else if((valid_in) && !(ready_out)) begin
			req_delay <= req_delay + 1; 
		end  
	end 
	always_ff@(posedge clk) begin 
		if (past_check && !$past(rst) && $past(valid_in) && !$past(ready_out)) begin 
			assert(req_delay <= 4'd10);
		end 
	end 

	// Specification checking //
	// !ready_out |-> ##1 (counter == $past(counter) -1);
	// valid_in && ready_out |-> ##1 (counter_out == 4'ha) && !ready_out;
	// counter_out >= '0;
	always_ff@(posedge clk) begin 
		if(past_check && !$past(rst) && !$past(ready_out)) begin
			assert(counter_out == $past(counter_out) - 1 ); 
		end

		if (past_check && !$past(rst) && $past(valid_in) && $past(ready_out)) begin
			assert(counter_out == 4'ha);
			assert(!ready_out);
		end 

		if(past_check) begin
			assert(counter_out >= 0);
			assert(counter_out <= 4'ha);
		end
	end 

	// Cover properties to make sure we don't overconstraint our signals

	// ready_out |-> ##1 !ready_out
	always_ff@(posedge clk) begin
		if (!$past(rst) && past_check) begin 
			cover( $past(!ready_out) && ready_out);
			cover($past(req_delay == 4'd2) && (req_delay == '0));
			cover();
		end 
	end



endmodule
