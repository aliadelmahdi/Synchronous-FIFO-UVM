////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module golden_model(data_in, wr_en, rd_en, clk, rst_n, full, empty, almostfull, almostempty, wr_ack, overflow, underflow, data_out);
	parameter FIFO_WIDTH = 16;
	parameter FIFO_DEPTH = 8;
	input [FIFO_WIDTH-1:0] data_in;
	input clk, rst_n, wr_en, rd_en;
	output reg [FIFO_WIDTH-1:0] data_out;
	output reg wr_ack, overflow;
	output full, empty, almostfull, almostempty, underflow;
	
	localparam max_fifo_addr = $clog2(FIFO_DEPTH);

	
endmodule