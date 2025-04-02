////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(data_in, wr_en, rd_en, clk, rst_n, full, empty, almostfull, almostempty, wr_ack, overflow, underflow, data_out);
	parameter FIFO_WIDTH = 16;
	parameter FIFO_DEPTH = 8;
	input [FIFO_WIDTH-1:0] data_in;
	input clk, rst_n, wr_en, rd_en;
	output reg [FIFO_WIDTH-1:0] data_out;
	output reg wr_ack;
	output full, empty, almostfull, almostempty, underflow;
	output  overflow;
	
	localparam max_fifo_addr = $clog2(FIFO_DEPTH);

	reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

	reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
	reg [max_fifo_addr:0] fifo_size;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			wr_ptr <= 0;
			wr_ack <= 0; // fixed this line for the designer
		end
		else if (wr_en && fifo_size != FIFO_DEPTH) begin  // fixed this line for the designer
			mem[wr_ptr] <= data_in;
			wr_ack <= 1;
			wr_ptr <= wr_ptr + 1;
		end
		else begin 
			wr_ack <= 0; 
		end
	end

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			rd_ptr <= 0;
			data_out <= 0;	// fixed this line for the designer
		end
		else if (rd_en && fifo_size != 0) begin
			data_out <= mem[rd_ptr];
			rd_ptr <= rd_ptr + 1;
		end
	end

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			fifo_size <= 0;
		end
		else begin
			if	( ({wr_en, rd_en} == 2'b10) && !full) 
				fifo_size <= fifo_size + 1;
			else if (({wr_en, rd_en} == 2'b01) && !empty)
				fifo_size <= fifo_size - 1;
			else if (({wr_en, rd_en} == 2'b11) && empty) // fixed this line for the designer
				fifo_size <= fifo_size + 1; // fixed this line for the designer
			else if (({wr_en, rd_en} == 2'b11) && full) // fixed this line for the designer
				fifo_size <= fifo_size - 1; // fixed this line for the designer
		end
	end

	assign full = (fifo_size == FIFO_DEPTH)? 1 : 0;
	assign empty = (fifo_size == 0)? 1 : 0;
	assign underflow = (empty && rd_en)? 1 : 0; 
	assign almostfull = (fifo_size == FIFO_DEPTH-1)? 1 : 0; // fixed this line for the designer
	assign almostempty = (fifo_size == 1)? 1 : 0;
	assign overflow = (full & wr_en)? 1 : 0;	// fixed this line for the designer

endmodule