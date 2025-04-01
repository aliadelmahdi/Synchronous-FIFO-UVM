
package FIFO_test_pkg;
    import  uvm_pkg::*,
            FIFO_env_pkg::*,
            FIFO_config_pkg::*,
            FIFO_driver_pkg::*,
            FIFO_main_sequence_pkg::*,
            FIFO_reset_sequence_pkg::*,
            FIFO_seq_item_pkg::*;
    `include "uvm_macros.svh"
    class FIFO_test extends uvm_test;
        `uvm_component_utils(FIFO_test)
        FIFO_env fifo_env; // Enviroment handle to the FIFO
        FIFO_config fifo_cnfg; // FIFO configuration
        virtual FIFO_if fifo_if; // Virtual interface handle
        FIFO_main_sequence fifo_main_seq; // FIFO main test sequence
        FIFO_reset_sequence fifo_reset_seq; // FIFO reset test sequence

        // Default constructor
        function new(string name = "FIFO_test", uvm_component parent);
            super.new(name,parent);
        endfunction

        // Build Phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase); // Call parent class's build_phase
            // Create instances from the UVM factory
            fifo_env = FIFO_env::type_id::create("env",this);
            fifo_cnfg = FIFO_config::type_id::create("FIFO_config",this);
            fifo_main_seq = FIFO_main_sequence::type_id::create("FIFO_main_seq",this);
            fifo_reset_seq = FIFO_reset_sequence::type_id::create("reset_seq",this);

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
            fifo_reset_seq.start(fifo_env.fifo_agent.fifo_seqr);
            `uvm_info("run_phase","Reset Deasserted",UVM_LOW)
            // Main Sequence
            `uvm_info("run_phase", "Stimulus Generation Started",UVM_LOW)
            fifo_main_seq.start(fifo_env.fifo_agent.fifo_seqr);
            `uvm_info("run_phase", "Stimulus Generation Ended",UVM_LOW) 

            phase.drop_objection(this); // Drop the objection to allow the test to complete
        endtask

    endclass : FIFO_test
    
endpackage : FIFO_test_pkg