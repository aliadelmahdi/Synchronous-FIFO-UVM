package FIFO_main_sequence_pkg;

    import uvm_pkg::*,
           FIFO_seq_item_pkg::*;
    `include "uvm_macros.svh"
    `include "FIFO_defines.svh" // For macros

    class FIFO_main_sequence extends uvm_sequence #(FIFO_seq_item);

        `uvm_object_utils (FIFO_main_sequence);
        FIFO_seq_item seq_item;

        function new(string name = "FIFO_main_sequence");
            super.new(name);            
        endfunction
        
        task body;

            repeat(`TEST_ITER_SMALL) begin
                seq_item = FIFO_seq_item::type_id::create("seq_item");
                start_item(seq_item);
                assert(seq_item.randomize()) else $error("Master Randomization Failed");
                finish_item(seq_item);
            end

        endtask
        
    endclass : FIFO_main_sequence

endpackage : FIFO_main_sequence_pkg