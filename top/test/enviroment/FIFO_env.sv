package FIFO_env_pkg; 
    import  uvm_pkg::*,
            FIFO_driver_pkg::*,
            FIFO_scoreboard_pkg::*,
            FIFO_main_sequence_pkg::*,
            FIFO_reset_sequence_pkg::*,
            FIFO_seq_item_pkg::*,
            FIFO_sequencer_pkg::*,
            FIFO_monitor_pkg::*,
            FIFO_config_pkg::*,
            FIFO_agent_pkg::*,
            FIFO_coverage_pkg::*;
    `include "uvm_macros.svh"
    class FIFO_env extends uvm_env;
        `uvm_component_utils(FIFO_env)

        FIFO_agent fifo_agent;
        FIFO_scoreboard fifo_sb;
        FIFO_coverage fifo_cov;
        
        // Default Constructor
        function new (string name = "FIFO_env", uvm_component parent);
            super.new(name,parent);
        endfunction

        // Build Phase
        function void build_phase(uvm_phase phase );
        super.build_phase (phase);
            fifo_agent = FIFO_agent::type_id::create("fifo_agent",this);
            fifo_sb= FIFO_scoreboard::type_id::create("fifo_sb",this);
            fifo_cov= FIFO_coverage::type_id::create("fifo_cov",this);
        endfunction

        // Connect Phase
        function void connect_phase (uvm_phase phase );
            fifo_agent.fifo_agent_ap.connect(fifo_sb.FIFO_sb_export);
            fifo_agent.fifo_agent_ap.connect(fifo_cov.FIFO_cov_export);
        endfunction

        // Run Phase
        task run_phase (uvm_phase phase);
            super.run_phase(phase);
        endtask
    endclass : FIFO_env
endpackage : FIFO_env_pkg