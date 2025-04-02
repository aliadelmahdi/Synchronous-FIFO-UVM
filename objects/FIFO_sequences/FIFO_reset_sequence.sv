package FIFO_reset_sequence_pkg;

    import uvm_pkg::*,
           FIFO_seq_item_pkg::*;
    `include "uvm_macros.svh"
    `include "FIFO_defines.svh"
           
    class FIFO_reset_sequence extends uvm_sequence #(FIFO_seq_item);

        `uvm_object_utils (FIFO_reset_sequence)
        FIFO_seq_item seq_item;

        function new (string name = "FIFO_reset_sequence");
            super.new(name);
        endfunction

        task body;
            seq_item = FIFO_seq_item::type_id::create("seq_item");
            start_item(seq_item);
                seq_item.rst_n = `LOW;
                seq_item.data_in = `LOW;
                seq_item.rd_en = `LOW;
                seq_item.wr_en = `LOW;
            finish_item(seq_item);
        endtask
        
    endclass : FIFO_reset_sequence

endpackage : FIFO_reset_sequence_pkg