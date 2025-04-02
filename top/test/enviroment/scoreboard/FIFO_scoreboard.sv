package FIFO_scoreboard_pkg;
    import  uvm_pkg::*,
            FIFO_seq_item_pkg::*;
    
    `include "FIFO_defines.svh" // For macros

    `include "uvm_macros.svh"
    class FIFO_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(FIFO_scoreboard)
        
        uvm_analysis_export #(FIFO_seq_item) FIFO_sb_export;
        uvm_tlm_analysis_fifo #(FIFO_seq_item) fifo_sb;
        FIFO_seq_item FIFO_seq_item_sb;


        int error_count = 0, correct_count = 0;
        
        // Default Constructor
        function new(string name = "FIFO_scoreboard",uvm_component parent);
            super.new(name,parent);
        endfunction

        // Build Phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            FIFO_sb_export = new("FIFO_sb_export",this);
            fifo_sb=new("fifo_sb",this);
        endfunction

        // Connect Phase
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            FIFO_sb_export.connect(fifo_sb.analysis_export);
        endfunction

        // Run Phase
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                fifo_sb.get(FIFO_seq_item_sb);
                check_results(FIFO_seq_item_sb);
            end
        endtask

        // Report Phase
        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase",$sformatf("At time %0t: Simulation Ends and Error count= %0d, Correct count= %0d",$time,error_count,correct_count),UVM_MEDIUM);
        endfunction

        function void check_results(FIFO_seq_item seq_item_ch);
            if (seq_item_ch.full != seq_item_ch.full_ref
             || seq_item_ch.data_out != seq_item_ch.data_out_ref
             || seq_item_ch.wr_ack != seq_item_ch.wr_ack_ref
             || seq_item_ch.overflow != seq_item_ch.overflow_ref
             || seq_item_ch.empty != seq_item_ch.empty_ref
             || seq_item_ch.almostfull != seq_item_ch.almostfull_ref
             || seq_item_ch.almostempty != seq_item_ch.almostempty_ref
             || seq_item_ch.underflow != seq_item_ch.underflow_ref
                ) begin
                error_count++;
                `uvm_error("run_phase","Comparison Error between the golden model and the DUT")
                `uvm_info("run_phase", $sformatf("FIFO Transaction:\n%s", seq_item_ch.sprint()), UVM_MEDIUM)
                
                if (seq_item_ch.full != seq_item_ch.full_ref)
                `uvm_info("run_phase", $sformatf("Mismatch: full (DUT = %0b, REF = %0b)", seq_item_ch.full, seq_item_ch.full_ref), UVM_MEDIUM)
        
                if (seq_item_ch.data_out != seq_item_ch.data_out_ref)
                    `uvm_info("run_phase", $sformatf("Mismatch: data_out (DUT = %0h, REF = %0h)", seq_item_ch.data_out, seq_item_ch.data_out_ref), UVM_MEDIUM)
            
                if (seq_item_ch.wr_ack != seq_item_ch.wr_ack_ref)
                    `uvm_info("run_phase", $sformatf("Mismatch: wr_ack (DUT = %0b, REF = %0b)", seq_item_ch.wr_ack, seq_item_ch.wr_ack_ref), UVM_MEDIUM)
            
                if (seq_item_ch.overflow != seq_item_ch.overflow_ref)
                    `uvm_info("run_phase", $sformatf("Mismatch: overflow (DUT = %0b, REF = %0b)", seq_item_ch.overflow, seq_item_ch.overflow_ref), UVM_MEDIUM)
            
                if (seq_item_ch.empty != seq_item_ch.empty_ref)
                    `uvm_info("run_phase", $sformatf("Mismatch: empty (DUT = %0b, REF = %0b)", seq_item_ch.empty, seq_item_ch.empty_ref), UVM_MEDIUM)
            
                if (seq_item_ch.almostfull != seq_item_ch.almostfull_ref)
                    `uvm_info("run_phase", $sformatf("Mismatch: almostfull (DUT = %0b, REF = %0b)", seq_item_ch.almostfull, seq_item_ch.almostfull_ref), UVM_MEDIUM)
            
                if (seq_item_ch.almostempty != seq_item_ch.almostempty_ref)
                    `uvm_info("run_phase", $sformatf("Mismatch: almostempty (DUT = %0b, REF = %0b)", seq_item_ch.almostempty, seq_item_ch.almostempty_ref), UVM_MEDIUM)
            
                if (seq_item_ch.underflow != seq_item_ch.underflow_ref)
                    `uvm_info("run_phase", $sformatf("Mismatch: underflow (DUT = %0b, REF = %0b)", seq_item_ch.underflow, seq_item_ch.underflow_ref), UVM_MEDIUM)
            
            end
            else
                correct_count++;
        endfunction
    endclass : FIFO_scoreboard

endpackage : FIFO_scoreboard_pkg