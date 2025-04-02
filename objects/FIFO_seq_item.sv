package FIFO_seq_item_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "FIFO_defines.svh" // For macros
    import shared_pkg::*;

    class FIFO_seq_item extends uvm_sequence_item;

        rand logic [FIFO_WIDTH-1:0] data_in;
        rand bit rst_n, wr_en, rd_en;

        logic [FIFO_WIDTH-1:0] data_out;
        logic wr_ack, overflow;
        logic full, empty, almostfull, almostempty, underflow;

        logic [FIFO_WIDTH-1:0] data_out_ref;
        logic wr_ack_ref, overflow_ref;
        logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;


        // Default Constructor
        function new(string name = "FIFO_seq_item");
            super.new(name);
        endfunction

        `uvm_object_utils_begin(FIFO_seq_item)
            `uvm_field_int(rst_n, UVM_DEFAULT)
            `uvm_field_int(wr_en, UVM_DEFAULT)
            `uvm_field_int(rd_en, UVM_DEFAULT)
            `uvm_field_int(data_in, UVM_DEFAULT)
            `uvm_field_int(data_out, UVM_DEFAULT)
            `uvm_field_int(data_out_ref, UVM_DEFAULT)
            `uvm_field_int(wr_ack, UVM_DEFAULT)
            `uvm_field_int(wr_ack_ref, UVM_DEFAULT)
            `uvm_field_int(overflow, UVM_DEFAULT)
            `uvm_field_int(overflow_ref, UVM_DEFAULT)
            `uvm_field_int(full, UVM_DEFAULT)
            `uvm_field_int(full_ref, UVM_DEFAULT)
            `uvm_field_int(empty, UVM_DEFAULT)
            `uvm_field_int(empty_ref, UVM_DEFAULT)
            `uvm_field_int(almostfull, UVM_DEFAULT)
            `uvm_field_int(almostfull_ref, UVM_DEFAULT)
            `uvm_field_int(almostempty, UVM_DEFAULT)
            `uvm_field_int(almostempty_ref, UVM_DEFAULT)
            `uvm_field_int(underflow, UVM_DEFAULT)
            `uvm_field_int(underflow_ref, UVM_DEFAULT)
        `uvm_object_utils_end

         // normal only
        constraint  rst_n_dist_c {
            rst_n dist {`HIGH:= 97, `LOW := 3 };
          }
      
        constraint write_only_c {
            wr_en == `HIGH;
            rd_en == `LOW;
        }

        constraint read_only_c {
            wr_en == `LOW;
            rd_en == `HIGH;
        }

        // High probability of writing than reading
        constraint write_ph_read_pl_c {
            wr_en dist { `HIGH:= 85, `LOW := 15 };
            rd_en dist {  `HIGH:= 15, `LOW := 85 };
        }

        // High probability of reading than writing
        constraint write_pl_read_ph_c {
            wr_en dist {  `HIGH:= 15, `LOW := 85 };
            rd_en dist { `HIGH:= 85, `LOW := 15 };
        }
        // Normal mode
        constraint normal_mode_c {
            wr_en dist {  `HIGH:= 50, `LOW := 50 };
            rd_en dist { `HIGH:= 50, `LOW := 50 };
        }

        constraint data_in_c {
            data_in dist {  
                ZERO          := 5,
                MAXIMUM       := 10,
                [1:MAXIMUM-1] :/ 85
                        };
        }
    endclass : FIFO_seq_item

endpackage : FIFO_seq_item_pkg