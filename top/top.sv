import uvm_pkg::*;
import FIFO_env_pkg::*;
import FIFO_test_pkg::*;
`include "FIFO_defines.svh" // For macros
`timescale `TIME_UNIT / `TIME_PRECISION

module tb_top;
    bit clk;
    // Clock Generation
    initial begin
        clk = `LOW;
        forever #(`CLK_PERIOD/2) clk = ~ clk;
    end

    
    FIFO_env env_instance;
    FIFO_test test;

    FIFO_if fifo_if (clk);
    FIFO DUT (
        .clk(fifo_if.clk),
        .rst_n(fifo_if.rst_n),
        .data_in(fifo_if.data_in),
        .wr_en(fifo_if.wr_en),
        .rd_en(fifo_if.rd_en),
        .data_out(fifo_if.data_out),
        .full(fifo_if.full),
        .empty(fifo_if.empty),
        .almostfull(fifo_if.almostfull),
        .almostempty(fifo_if.almostempty),
        .wr_ack(fifo_if.wr_ack),
        .overflow(fifo_if.overflow),
        .underflow(fifo_if.underflow)
    );

    golden_model GLD (
        .clk(fifo_if.clk),
        .rst_n(fifo_if.rst_n),
        .data_in(fifo_if.data_in),
        .wr_en(fifo_if.wr_en),
        .rd_en(fifo_if.rd_en),
        .data_out(fifo_if.data_out_ref),
        .full(fifo_if.full_ref),
        .empty(fifo_if.empty_ref),
        .almostfull(fifo_if.almostfull_ref),
        .almostempty(fifo_if.almostempty_ref),
        .wr_ack(fifo_if.wr_ack_ref),
        .overflow(fifo_if.overflow_ref),
        .underflow(fifo_if.underflow_ref)
    );

    bind FIFO FIFO_sva FIFO_sva_inst (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_out(data_out),
        .full(full),
        .empty(empty),
        .almostfull(almostfull),
        .almostempty(almostempty),
        .wr_ack(wr_ack),
        .overflow(overflow),
        .underflow(underflow)
    );    

    initial begin
        uvm_top.set_report_verbosity_level(UVM_MEDIUM); // Set verbosity level
        uvm_top.finish_on_completion = `DISABLE_FINISH; // Prevent UVM from calling $finish
        uvm_config_db#(virtual FIFO_if)::set(null, "*", "fifo_if", fifo_if); // Set FIFO interface globally
        run_test("FIFO_test"); // Start the UVM test
        $stop; // Stop simulation after test execution
    end
endmodule : tb_top