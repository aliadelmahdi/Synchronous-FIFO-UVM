package FIFO_agent_pkg;
    import  uvm_pkg::*,
            FIFO_seq_item_pkg::*,
            FIFO_driver_pkg::*,
            FIFO_sequences_pkg::*,
            FIFO_reset_sequence_pkg::*,
            FIFO_sequencer_pkg::*,
            FIFO_monitor_pkg::*,
            FIFO_config_pkg::*;
    `include "uvm_macros.svh"
 
    class FIFO_agent extends uvm_agent;

        `uvm_component_utils(FIFO_agent)
        FIFO_sequencer fifo_seqr;
        FIFO_driver fifo_drv;
        FIFO_monitor fifo_mon;
        FIFO_config fifo_cnfg;
        uvm_analysis_port #(FIFO_seq_item) fifo_agent_ap;

        // Default Constructor
        function new(string name = "FIFO_agent", uvm_component parent);
            super.new(name,parent);
        endfunction

        // Build Phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            if(!uvm_config_db #(FIFO_config)::get(this,"","CFG",fifo_cnfg)) 
                `uvm_fatal ("build_phase","Unable to get the FIFO configuration object from the database")
            
            fifo_drv = FIFO_driver::type_id::create("fifo_drv",this);
            fifo_seqr = FIFO_sequencer::type_id::create("fifo_seqr",this);
            fifo_mon = FIFO_monitor::type_id::create("fifo_mon",this);
            fifo_agent_ap = new("fifo_agent_ap",this);
        endfunction

        // Connect Phase
        function void connect_phase(uvm_phase phase);
            fifo_drv.fifo_if = fifo_cnfg.fifo_if;
            fifo_mon.fifo_if = fifo_cnfg.fifo_if;
            fifo_drv.seq_item_port.connect(fifo_seqr.seq_item_export);
            fifo_mon.monitor_ap.connect(fifo_agent_ap);
        endfunction

        // Run Phase
        task run_phase (uvm_phase phase);
            super.run_phase(phase);
        endtask
    endclass : FIFO_agent

endpackage : FIFO_agent_pkg