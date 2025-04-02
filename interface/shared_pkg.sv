package shared_pkg;
    parameter FAILED = 0;
    parameter SUCCESS = 1;
    parameter FIFO_WIDTH = 16;
	parameter FIFO_DEPTH = 8;
    parameter ZERO = 0;
    parameter MAXIMUM = (2**FIFO_DEPTH) - 1;
	parameter max_fifo_addr = $clog2(FIFO_DEPTH);
endpackage