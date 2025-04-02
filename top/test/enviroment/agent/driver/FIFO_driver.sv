package FIFO_driver_pkg;

    import  uvm_pkg::*,
            FIFO_config_pkg::*,
            FIFO_sequences_pkg::*,
            FIFO_reset_sequence_pkg::*,
            FIFO_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class FIFO_driver extends uvm_driver #(FIFO_seq_item);
        `uvm_component_utils(FIFO_driver)
        virtual FIFO_if fifo_if;
        FIFO_seq_item stimulus_seq_item;

        // Default Constructor
        function new(string name = "FIFO_driver", uvm_component parent);
            super.new(name,parent);
        endfunction

        // Build Phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
        endfunction

        // Connect Phase
        function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
		endfunction
        
        // Run Phase
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                stimulus_seq_item = FIFO_seq_item::type_id::create("FIFO_stimulus_seq_item");
                seq_item_port.get_next_item(stimulus_seq_item);
                fifo_if.rst_n = stimulus_seq_item.rst_n;
                fifo_if.data_in = stimulus_seq_item.data_in;
                fifo_if.wr_en = stimulus_seq_item.wr_en;
                fifo_if.rd_en = stimulus_seq_item.rd_en;
                @(negedge fifo_if.clk)
                seq_item_port.item_done();
                `uvm_info("run_phase",stimulus_seq_item.sprint(),UVM_HIGH)
            end
        endtask
        
    endclass : FIFO_driver

endpackage : FIFO_driver_pkg