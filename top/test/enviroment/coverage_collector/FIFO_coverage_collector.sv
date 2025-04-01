package FIFO_coverage_pkg;
    import  uvm_pkg::*,
            FIFO_driver_pkg::*,
            FIFO_scoreboard_pkg::*,
            FIFO_main_sequence_pkg::*,
            FIFO_reset_sequence_pkg::*,
            FIFO_seq_item_pkg::*,
            FIFO_sequencer_pkg::*,
            FIFO_monitor_pkg::*,
            FIFO_config_pkg::*,
            FIFO_agent_pkg::*;
    `include "uvm_macros.svh"

    class FIFO_coverage extends uvm_component;
        `uvm_component_utils(FIFO_coverage)

        // Analysis Export for receiving transactions from monitors
        uvm_analysis_export #(FIFO_seq_item) FIFO_cov_export;
        uvm_tlm_analysis_fifo #(FIFO_seq_item) FIFO_cov_fifo;
        FIFO_seq_item FIFO_seq_item_cov;

        // Covergroup definitions
        covergroup FIFO_cov_grp;
            
        endgroup
 
        // Constructor
        function new (string name = "FIFO_coverage", uvm_component parent);
            super.new(name, parent);
            FIFO_cov_grp = new();
        endfunction

        // Build Phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            FIFO_cov_export = new("FIFO_cov_export", this);
            FIFO_cov_fifo = new("FIFO_cov_fifo", this);
        endfunction

        // Connect Phase
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            FIFO_cov_export.connect(FIFO_cov_fifo.analysis_export);
        endfunction

        // Run Phase
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                // Get the next transaction from the analysis FIFO.
                FIFO_cov_fifo.get(FIFO_seq_item_cov);
                FIFO_cov_grp.sample();
            end
        endtask

    endclass : FIFO_coverage

endpackage : FIFO_coverage_pkg