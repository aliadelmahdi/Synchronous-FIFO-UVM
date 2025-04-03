/*  
    This assertion file follows the **Verification Plan** numbering  
    Each section corresponds to a specific verification requirement

    The numbers (e.g., 1, 2.2) match the corresponding test items  
    from the **Verification Plan** for traceability and clarity
*/

`include "FIFO_defines.svh" // For macros
`timescale `TIME_UNIT / `TIME_PRECISION
import shared_pkg::*;

module FIFO_sva(data_in, fifo_size, wr_ptr, rd_ptr, wr_en, rd_en, clk, rst_n, full, empty, almostfull, almostempty, wr_ack, overflow, underflow, data_out);
	parameter FIFO_WIDTH = 16;
	parameter FIFO_DEPTH = 8;
  	input logic [FIFO_WIDTH-1:0] data_in;
	input logic clk, rst_n, wr_en, rd_en;

	input logic [FIFO_WIDTH-1:0] data_out;
	input logic wr_ack, overflow;
	input logic full, empty, almostfull, almostempty, underflow;
	input logic [max_fifo_addr:0] fifo_size;
	input logic [max_fifo_addr-1:0] wr_ptr, rd_ptr;

	// ** 1: Reset Verification **\\

    // 1.1: Reset Behavior
	property check_reset;
		(!rst_n) |-> ( !data_out
					  && !wr_ack
					  && !overflow
					  && !full
					  && !empty
					  && !almostfull
					  && !almostempty
					  && !underflow 
					 );
	endproperty

	assert_reset: assert property (@(posedge clk or negedge rst_n) check_reset)
		else $error("Failed to assert reset");

	// ** 2: FIFO Flags **\\
  
    // 2.1: FIFO full
	property check_full;
		@(posedge clk) disable iff(!rst_n)
			(fifo_size==FIFO_DEPTH) |-> (full);
	endproperty

	assert_full: assert property (check_full)
		else $error("Failed to raise the FIFO full flag when the size equal FIFO depth");

    // 2.2: FIFO empty
	property check_empty;
		@(posedge clk) disable iff(!rst_n)
			(fifo_size==0) |-> (empty);
	endproperty

	assert_empty: assert property (check_empty)
		else $error("Failed to raise the FIFO empty flag when the size equal zero");

    // 2.3: FIFO almost full
	property check_almostfull;
		@(posedge clk) disable iff(!rst_n)
			(fifo_size==FIFO_DEPTH-1) |-> (almostfull);
	endproperty

	assert_almostfull: assert property (check_almostfull)
		else $error("Failed to raise the FIFO almost full flag when the size equal FIFO_depth-1");
		
    // 2.4: FIFO overflow
	property check_overflow;
		@(posedge clk) disable iff(!rst_n)
			(wr_en && full) |-> (overflow);
	endproperty

	assert_overflow: assert property (check_overflow)
		else $error("Failed to raise the FIFO overflow flag");
			
    // 2.5: FIFO underflow
	property check_underflow;
		@(posedge clk) disable iff(!rst_n)
			(rd_en && empty) |-> (underflow);
	endproperty

	assert_underflow: assert property (check_underflow)
		else $error("Failed to raise the FIFO underflow flag");
			
    // 2.6: FIFO almost empty
	property check_almostempty;
		@(posedge clk) disable iff(!rst_n)
			(fifo_size==1) |-> (almostempty);
	endproperty

	assert_almostempty: assert property (check_almostempty)
		else $error("Failed to raise the FIFO almost empty flag when the size equal 1");

	// ** 3: Read & Write Operation **\\

    // 3.1: Priority to Write Operation
	property check_pr_write;
		@(posedge clk) disable iff(!rst_n)
			(rd_en && wr_en && empty) |=> (data_out == $past(data_out) && wr_ack && fifo_size == $past(fifo_size) +1);
	endproperty

	assert_pr_write: assert property (check_pr_write)
		else $error("Failed to ensure that when both read and write enables are HIGH and the FIFO is empty, only writing will take place");
	
	// 3.2: Priority to Read Operation
	property check_pr_read;
		@(posedge clk) disable iff(!rst_n)
			(rd_en && wr_en && full) |=> (fifo_size == $past(fifo_size) -1 && !wr_ack);
	endproperty

	assert_pr_read: assert property (check_pr_read)
		else $error("Failed to ensure that when a read and write enables are HIGH and the FIFO is full, only reading will take place");
		
	// 3.3: Write Acknowledge is asserted
	property check_wr_en_high;
		@(posedge clk) disable iff(!rst_n)
			(wr_en && !full) |=> (wr_ack);
	endproperty

	assert_wr_en_high: assert property (check_wr_en_high)
		else $error("Failed to assert wr_ack");

	// 3.4: Write Acknowledge is deasserted
	property check_wr_en_low;
		@(posedge clk) disable iff(!rst_n)
			(wr_en && full) |=> (!wr_ack);
	endproperty

	assert_wr_en_low: assert property (check_wr_en_low)
		else $error("Failed to assert wr_ack");
			
endmodule