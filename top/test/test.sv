
package FIFO_test_pkg;
    import  uvm_pkg::*,
            FIFO_env_pkg::*,
            FIFO_config_pkg::*,
            FIFO_driver_pkg::*,
            FIFO_sequences_pkg::*,
            FIFO_reset_sequence_pkg::*,
            FIFO_seq_item_pkg::*;
    `include "uvm_macros.svh"
    class FIFO_test extends uvm_test;
        `uvm_component_utils(FIFO_test)
        FIFO_env fifo_env; // Enviroment handle to the FIFO
        FIFO_config fifo_cnfg; // FIFO configuration
        virtual FIFO_if fifo_if; // Virtual interface handle
        FIFO_normal_mode_sequence fifo_normal_mode_seq;
        FIFO_write_only_sequence fifo_write_only_sequence;
        FIFO_read_only_sequence fifo_read_only_sequence;
        FIFO_write_pl_read_ph_sequence fifo_write_pl_read_ph_sequence;
        FIFO_write_ph_read_pl_sequence fifo_write_ph_read_pl_sequence;
        FIFO_reset_sequence fifo_reset_sequence; // FIFO reset test sequence

        // Default constructor
        function new(string name = "FIFO_test", uvm_component parent);
            super.new(name,parent);
        endfunction

        // Build Phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase); // Call parent class's build_phase
            factory.print();
            // Create instances from the UVM factory
            fifo_env = FIFO_env::type_id::create("env",this);
            fifo_cnfg = FIFO_config::type_id::create("FIFO_config",this);
            fifo_normal_mode_seq = FIFO_normal_mode_sequence::type_id::create("fifo_normal_mode_seq",this);
            fifo_read_only_sequence = FIFO_read_only_sequence::type_id::create("fifo_read_only_sequence",this);
            fifo_write_only_sequence = FIFO_write_only_sequence::type_id::create("fifo_write_only_sequence",this);
            fifo_write_ph_read_pl_sequence = FIFO_write_ph_read_pl_sequence::type_id::create("fifo_write_ph_read_pl_sequence",this);
            fifo_write_pl_read_ph_sequence = FIFO_write_pl_read_ph_sequence::type_id::create("fifo_write_pl_read_ph_sequence",this);
            fifo_reset_sequence = FIFO_reset_sequence::type_id::create("fifo_reset_sequence",this);
            // Retrieve the virtual interface for FIFO FIFO from the UVM configuration database
            if(!uvm_config_db #(virtual FIFO_if)::get(this,"","fifo_if",fifo_cnfg.fifo_if))  
                `uvm_fatal("build_phase" , " test - Unable to get the FIFO virtual interface of the FIFO form the configuration database");
        
            uvm_config_db # (FIFO_config)::set(this , "*" , "CFG",fifo_cnfg);
        endfunction

        // Run Phase
        task run_phase(uvm_phase phase);
            super.run_phase(phase); // Call parent class's run phase
            phase.raise_objection(this); // Raise an objection to prevent the test from ending
            // Reset sequence
            `uvm_info("run_phase","stimulus Generation started",UVM_LOW)
            fifo_reset_sequence.start(fifo_env.fifo_agent.fifo_seqr);
            `uvm_info("run_phase","Reset Deasserted",UVM_LOW)
            // Main Sequence
            `uvm_info("run_phase", "Stimulus Generation Started",UVM_LOW)
            fifo_write_only_sequence.start(fifo_env.fifo_agent.fifo_seqr);
            fifo_read_only_sequence.start(fifo_env.fifo_agent.fifo_seqr);
            fifo_write_ph_read_pl_sequence.start(fifo_env.fifo_agent.fifo_seqr);
            fifo_write_pl_read_ph_sequence.start(fifo_env.fifo_agent.fifo_seqr);
            fifo_normal_mode_seq.start(fifo_env.fifo_agent.fifo_seqr);
            `uvm_info("run_phase", "Stimulus Generation Ended",UVM_LOW) 

            phase.drop_objection(this); // Drop the objection to allow the test to complete
        endtask

    endclass : FIFO_test
    
endpackage : FIFO_test_pkg