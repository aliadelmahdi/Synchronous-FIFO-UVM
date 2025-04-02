package FIFO_coverage_pkg;
    import  uvm_pkg::*,
            FIFO_driver_pkg::*,
            FIFO_scoreboard_pkg::*,
            FIFO_sequences_pkg::*,
            FIFO_reset_sequence_pkg::*,
            FIFO_seq_item_pkg::*,
            FIFO_sequencer_pkg::*,
            FIFO_monitor_pkg::*,
            FIFO_config_pkg::*,
            FIFO_agent_pkg::*;
    `include "uvm_macros.svh"
    import shared_pkg::*;
    `include "FIFO_defines.svh"
    class FIFO_coverage extends uvm_component;
        `uvm_component_utils(FIFO_coverage)

        // Analysis Export for receiving transactions from monitors
        uvm_analysis_export #(FIFO_seq_item) FIFO_cov_export;
        uvm_tlm_analysis_fifo #(FIFO_seq_item) FIFO_cov_fifo;
        FIFO_seq_item FIFO_seq_item_cov;

        // Covergroup definitions
        covergroup FIFO_cov_grp;
            full_cp: coverpoint FIFO_seq_item_cov.full {
                bins FIFO_FULL = {`HIGH};
                bins FIFO_NOT_FULL = {`LOW};
                bins active_to_inactive = (`HIGH=>`LOW);
                bins inactive_to_active = (`LOW=>`HIGH);
            }
            empty_cp: coverpoint FIFO_seq_item_cov.empty {
                bins FIFO_EMPTY = {`HIGH};
                bins FIFO_NOT_EMPTY = {`LOW};
                bins active_to_inactive = (`HIGH=>`LOW);
                bins inactive_to_active = (`LOW=>`HIGH);
            }
           
            almostempty_cp: coverpoint FIFO_seq_item_cov.almostempty {
                bins FIFO_ALMOSTEMPTY = {`HIGH};
                bins FIFO_NOT_ALMOSTEMPTY  = {`LOW};
                bins active_to_inactive = (`HIGH=>`LOW);
                bins inactive_to_active = (`LOW=>`HIGH);
            }

            overflow_cp: coverpoint FIFO_seq_item_cov.overflow {
                bins active = {`HIGH};
                bins inactive  = {`LOW};
                bins active_to_inactive = (`HIGH=>`LOW);
                bins inactive_to_active = (`LOW=>`HIGH);
            }
            underflow_cp: coverpoint FIFO_seq_item_cov.underflow {
                bins active = {`HIGH};
                bins inactive  = {`LOW};
                bins active_to_inactive = (`HIGH=>`LOW);
                bins inactive_to_active = (`LOW=>`HIGH);
            }

            wr_en_cp: coverpoint FIFO_seq_item_cov.wr_en {
                bins active = {`HIGH};
                bins inactive  = {`LOW};
                bins active_to_inactive = (`HIGH=>`LOW);
                bins inactive_to_active = (`LOW=>`HIGH);
            }
            rd_en_cp: coverpoint FIFO_seq_item_cov.rd_en {
                bins active = {`HIGH};
                bins inactive  = {`LOW};
                bins active_to_inactive = (`HIGH=>`LOW);
                bins inactive_to_active = (`LOW=>`HIGH);
            }
            wr_ack_cp: coverpoint FIFO_seq_item_cov.wr_ack {
                bins active = {`HIGH};
                bins inactive  = {`LOW};
                bins active_to_inactive = (`HIGH=>`LOW);
                bins inactive_to_active = (`LOW=>`HIGH);
            }
            rst_n_cp: coverpoint FIFO_seq_item_cov.rst_n {
                bins active  = {`LOW};
                bins inactive= {`HIGH};
                bins active_to_inactive = (`LOW=>`HIGH);
                bins inactive_to_active = (`HIGH=>`LOW);
            }
            data_out_cp: coverpoint FIFO_seq_item_cov.data_out {
                bins ZERO = {ZERO};
                bins MAXIMUM  = {MAXIMUM};
                bins OUTPUT = default;
            }

            wr_en_w_ack_cr: cross wr_en_cp, wr_ack_cp {
                bins deassert_wr_ack = binsof(wr_en_cp.inactive) && binsof (wr_ack_cp.active_to_inactive);
                bins assert_wr_ack = binsof(wr_en_cp.active) && binsof (wr_ack_cp.active_to_inactive);
                option.cross_auto_bin_max = 0;
            }
            almostfull_cp: coverpoint FIFO_seq_item_cov.almostfull {
                bins FIFO_ALMOSTFULL = {`HIGH};
                bins FIFO_NOT_ALMOSTFULL = {`LOW};
                bins active_to_inactive = (`HIGH=>`LOW);
                bins inactive_to_active = (`LOW=>`HIGH);
            }
            // FIFO Flags Cross write operation
            wr_ack_almostfull_wr_en_cr: cross wr_ack_cp, almostfull_cp, wr_en_cp {
                bins success_almostfull = binsof(almostfull_cp.inactive_to_active) && binsof (wr_ack_cp.active) && binsof(wr_en_cp.active);
                
                bins assert_almostfull = binsof(almostfull_cp.inactive_to_active) && binsof (wr_en_cp.active);
                bins deassert_almostfull = binsof(almostfull_cp.active_to_inactive) && binsof (wr_en_cp.active);
                bins almostfull_active = binsof(almostfull_cp.FIFO_ALMOSTFULL) && binsof (wr_en_cp.active);
                bins almostfull_inactive = binsof(almostfull_cp.FIFO_NOT_ALMOSTFULL) && binsof (wr_en_cp.active);
                option.cross_auto_bin_max = 0;
            }
            wr_ack_almostempty_wr_en_cr: cross wr_ack_cp, almostempty_cp, wr_en_cp {
                bins success_almostempty = binsof(almostempty_cp.active_to_inactive) && binsof (wr_ack_cp.active) && binsof(wr_en_cp.active);
                
                bins assert_almostempty = binsof(almostempty_cp.inactive_to_active) && binsof (wr_en_cp.active);
                bins deassert_almostempty = binsof(almostempty_cp.active_to_inactive) && binsof (wr_en_cp.active);
                bins almostempty_active = binsof(almostempty_cp.FIFO_ALMOSTEMPTY) && binsof (wr_en_cp.active);
                bins almostempty_inactive = binsof(almostempty_cp.FIFO_NOT_ALMOSTEMPTY) && binsof (wr_en_cp.active);
                option.cross_auto_bin_max = 0;
            }
            wr_ack_empty_wr_en_cr: cross wr_ack_cp, empty_cp, wr_en_cp {
                bins success_empty = binsof(empty_cp.active_to_inactive) && binsof (wr_ack_cp.active) && binsof(wr_en_cp.active);
                
                bins assert_empty  = binsof(empty_cp.inactive_to_active) && binsof (wr_en_cp.active);
                bins deassert_empty = binsof(empty_cp.active_to_inactive) && binsof (wr_en_cp.active);
                bins empty_active = binsof(empty_cp.FIFO_EMPTY) && binsof (wr_en_cp.active);
                bins empty_inactive = binsof(empty_cp.FIFO_NOT_EMPTY) && binsof (wr_en_cp.active);
                option.cross_auto_bin_max = 0;
            }
            wr_ack_full_wr_en_cr: cross wr_ack_cp, full_cp, wr_en_cp {
                bins success_full = binsof(full_cp.inactive_to_active) && binsof (wr_ack_cp.active) && binsof(wr_en_cp.active);
                bins success_ignore_write_op = binsof(full_cp.FIFO_FULL) && binsof (wr_ack_cp.inactive) && binsof(wr_en_cp.active);
               
                bins assert_full = binsof(full_cp.inactive_to_active) && binsof (wr_en_cp.active);
                bins deassert_full= binsof(full_cp.active_to_inactive) && binsof (wr_en_cp.active);
                bins full_active = binsof(full_cp.FIFO_FULL) && binsof (wr_en_cp.active);
                bins full_inactive = binsof(full_cp.FIFO_NOT_FULL) && binsof (wr_en_cp.active);
                option.cross_auto_bin_max = 0;
            }
            full_almostfull_cr: cross full_cp, almostfull_cp {
                bins full_to_almost_full = binsof(full_cp.active_to_inactive) && binsof(almostfull_cp.inactive_to_active);
                bins almostfull_to_full = binsof(full_cp.inactive_to_active) && binsof(almostfull_cp.active_to_inactive);
                option.cross_auto_bin_max = 0;
            }
            
            overflow_cr: cross overflow_cp, full_cp, wr_en_cp, wr_ack_cp {
                bins success_overflow = binsof(overflow_cp.inactive_to_active) && binsof (full_cp.FIFO_FULL) 
                                     && binsof(wr_en_cp.active) && binsof (wr_ack_cp.inactive); 
                option.cross_auto_bin_max = 0;
            }
            // FIFO Flags Cross read operation
            underflow_cr: cross underflow_cp, empty_cp, rd_en_cp {
                bins success_underflow = binsof(underflow_cp.inactive_to_active) && binsof (empty_cp.FIFO_EMPTY) 
                                     && binsof(rd_en_cp.active); 
                option.cross_auto_bin_max = 0;
            }
            empty_almostempty_cr: cross empty_cp, almostempty_cp {
                bins empty_to_almostempty = binsof(empty_cp.active_to_inactive) && binsof(almostempty_cp.inactive_to_active);
                bins almostempty_to_empty = binsof(empty_cp.inactive_to_active) && binsof(almostempty_cp.active_to_inactive);
                option.cross_auto_bin_max = 0;
            }


            almostfull_rd_en_cr: cross almostfull_cp, rd_en_cp {
                bins success_almostfull = binsof(almostfull_cp.active_to_inactive) && binsof(rd_en_cp.active);
                
                bins almostfull_active = binsof(almostfull_cp.FIFO_ALMOSTFULL) && binsof (rd_en_cp.active);
                bins almostfull_inactive = binsof(almostfull_cp.FIFO_NOT_ALMOSTFULL) && binsof (rd_en_cp.active);
                option.cross_auto_bin_max = 0;
            }
            almostempty_rd_en_cr: cross almostempty_cp, rd_en_cp {
                bins success_almostempty = binsof(almostempty_cp.active_to_inactive) && binsof(rd_en_cp.active);

                bins almostempty_active = binsof(almostempty_cp.FIFO_ALMOSTEMPTY) && binsof (rd_en_cp.active);
                bins almostempty_inactive = binsof(almostempty_cp.FIFO_NOT_ALMOSTEMPTY) && binsof (rd_en_cp.active);
                option.cross_auto_bin_max = 0;
            }
          
            full_rd_en_cr: cross full_cp, rd_en_cp {
                bins success_full = binsof(full_cp.active_to_inactive) && binsof(rd_en_cp.active);

                bins full_active = binsof(full_cp.FIFO_FULL) && binsof (rd_en_cp.inactive);
                bins full_inactive = binsof(full_cp.FIFO_NOT_FULL) && binsof (rd_en_cp.active);
                option.cross_auto_bin_max = 0;
            }
            
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