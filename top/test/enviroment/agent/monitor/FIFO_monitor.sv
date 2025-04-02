package FIFO_monitor_pkg;

    import uvm_pkg::*,
           FIFO_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class FIFO_monitor extends uvm_monitor;
        `uvm_component_utils (FIFO_monitor)
        virtual FIFO_if fifo_if;
        FIFO_seq_item response_seq_item;
        uvm_analysis_port #(FIFO_seq_item) monitor_ap;

        function new(string name = "FIFO_monitor",uvm_component parent);
            super.new(name,parent);
        endfunction

        // Build Phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            monitor_ap = new ("monitor_ap",this);
        endfunction

        // Connect Phase
        function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
		endfunction

        // Run Phase
        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            forever begin
                response_seq_item = FIFO_seq_item::type_id::create("response_seq_item");
                @(negedge fifo_if.clk);
                response_seq_item.data_in = fifo_if.data_in;
                response_seq_item.rst_n = fifo_if.rst_n;
                response_seq_item.wr_en = fifo_if.wr_en;
                response_seq_item.rd_en = fifo_if.rd_en;
                response_seq_item.data_out = fifo_if.data_out;
                response_seq_item.wr_ack = fifo_if.wr_ack;
                response_seq_item.overflow = fifo_if.overflow;
                response_seq_item.full = fifo_if.full;
                response_seq_item.empty = fifo_if.empty;
                response_seq_item.almostfull = fifo_if.almostfull;
                response_seq_item.almostempty = fifo_if.almostempty;
                response_seq_item.underflow = fifo_if.underflow;
                // Golden Model
                response_seq_item.data_out_ref = fifo_if.data_out_ref;
                response_seq_item.wr_ack_ref = fifo_if.wr_ack_ref;
                response_seq_item.overflow_ref = fifo_if.overflow_ref;
                response_seq_item.full_ref = fifo_if.full_ref;
                response_seq_item.empty_ref = fifo_if.empty_ref;
                response_seq_item.almostfull_ref = fifo_if.almostfull_ref;
                response_seq_item.almostempty_ref = fifo_if.almostempty_ref;
                response_seq_item.underflow_ref = fifo_if.underflow_ref;
                monitor_ap.write(response_seq_item);
                `uvm_info("run_phase", response_seq_item.sprint(), UVM_HIGH)
            end

        endtask
        
    endclass : FIFO_monitor

endpackage : FIFO_monitor_pkg