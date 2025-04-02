`include "FIFO_defines.svh" // For macros
`timescale `TIME_UNIT / `TIME_PRECISION

module FIFO_sva(data_in, wr_en, rd_en, clk, rst_n, full, empty, almostfull, almostempty, wr_ack, overflow, underflow, data_out);
	parameter FIFO_WIDTH = 16;
	parameter FIFO_DEPTH = 8;
  	input logic [FIFO_WIDTH-1:0] data_in;
	input logic clk, rst_n, wr_en, rd_en;
	input logic [FIFO_WIDTH-1:0] data_out;
	input logic wr_ack, overflow;
	input logic full, empty, almostfull, almostempty, underflow;

endmodule