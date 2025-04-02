import shared_pkg::*;
`include "FIFO_defines.svh"
module golden_model(data_in, wr_en, rd_en, clk, rst_n, full, empty, almostfull, almostempty, wr_ack, overflow, underflow, data_out);
	input logic [FIFO_WIDTH-1:0] data_in;
	input logic clk, rst_n, wr_en, rd_en;
	output logic [FIFO_WIDTH-1:0] data_out;
	output logic wr_ack, overflow;
	output logic full, empty, almostfull, almostempty, underflow;
	

	logic [FIFO_WIDTH-1:0] fifo[$:7];
	logic wr_ack_temp;
	logic [max_fifo_addr:0] fifo_size;

	always @(posedge clk, negedge rst_n) begin
		if(!rst_n) begin
			data_out <=0;
			fifo.delete();
			wr_ack <=FAILED;
			wr_ack_temp <= FAILED;
		end else begin
			if (wr_en && !(fifo.size()==FIFO_DEPTH)) begin
				fifo.push_front(data_in);
				wr_ack_temp = SUCCESS;
			end
			wr_ack <= (full || !wr_en) ? FAILED : wr_ack_temp;
			if(rd_en && !empty) begin
				data_out <= fifo.pop_back();
			end
		end
	end
	assign full = (fifo.size()==FIFO_DEPTH) ? 1 : 0;
	assign empty = (fifo.size()==0) ? 1 : 0;
	assign almostfull = (fifo.size()==FIFO_DEPTH-1) ? 1 : 0;
	assign almostempty = (fifo.size()==1) ? 1 : 0;
	
	assign underflow = ( (fifo.size()==0) && rd_en ) ? 1 : 0;
	assign overflow = ( (fifo.size()==FIFO_DEPTH) && wr_en ) ? 1 : 0;
	assign fifo_size = fifo.size();
endmodule