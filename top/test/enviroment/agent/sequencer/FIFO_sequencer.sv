package FIFO_sequencer_pkg;

    import uvm_pkg::*,
           FIFO_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class FIFO_sequencer extends uvm_sequencer #(FIFO_seq_item);

        `uvm_component_utils(FIFO_sequencer);

        function new(string name = "FIFO_sequence", uvm_component parent);
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
        task run_phase (uvm_phase phase);
            super.run_phase(phase);
        endtask
    endclass : FIFO_sequencer

endpackage : FIFO_sequencer_pkg