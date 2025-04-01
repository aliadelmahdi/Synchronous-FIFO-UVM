package FIFO_seq_item_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "FIFO_defines.svh" // For macros

    class FIFO_seq_item extends uvm_sequence_item;

        parameter FIFO_WIDTH = 16;
        parameter FIFO_DEPTH = 8;
    
        rand [FIFO_WIDTH-1:0] data_in;
        rand rst_n, wr_en, rd_en;

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
            `uvm_field_int(rst_n, UVM_BIN)
            `uvm_field_int(wr_en, UVM_BIN)
            `uvm_field_int(rd_en, UVM_BIN)
            `uvm_field_int(data_in, UVM_BIN)
            `uvm_field_int(data_out, UVM_BIN)
            `uvm_field_int(data_out_ref, UVM_BIN)
            `uvm_field_int(wr_ack, UVM_BIN)
            `uvm_field_int(wr_ack_ref, UVM_BIN)
            `uvm_field_int(overflow, UVM_BIN)
            `uvm_field_int(overflow_ref, UVM_BIN)
            `uvm_field_int(full, UVM_BIN)
            `uvm_field_int(full_ref, UVM_BIN)
            `uvm_field_int(empty, UVM_BIN)
            `uvm_field_int(empty_ref, UVM_BIN)
            `uvm_field_int(almostfull, UVM_BIN)
            `uvm_field_int(almostfull_ref, UVM_BIN)
            `uvm_field_int(almostempty, UVM_BIN)
            `uvm_field_int(almostempty_ref, UVM_BIN)
            `uvm_field_int(underflow, UVM_BIN)
            `uvm_field_int(underflow_ref, UVM_BIN)
        `uvm_object_utils_end

    endclass : FIFO_seq_item

endpackage : FIFO_seq_item_pkg