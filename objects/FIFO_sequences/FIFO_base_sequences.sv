package FIFO_sequences_pkg;

    import uvm_pkg::*;
    import FIFO_seq_item_pkg::*;
    `include "uvm_macros.svh"
    `include "FIFO_defines.svh" // For macros

    class FIFO_base_sequence extends uvm_sequence #(FIFO_seq_item);

        `uvm_object_utils(FIFO_base_sequence)
        FIFO_seq_item seq_item;

        function new(string name = "FIFO_base_sequence");
            super.new(name);            
        endfunction

        // Configure the sequence item
        function void configure_seq_item();
            seq_item = FIFO_seq_item::type_id::create("seq_item");
            `disable_constraints
            `enable_constraint (rst_n_dist_c)
            `enable_constraint (data_in_c)
        endfunction

        virtual task body;
        endtask

    endclass : FIFO_base_sequence

    class FIFO_normal_mode_sequence extends FIFO_base_sequence;

        `uvm_object_utils(FIFO_normal_mode_sequence)

        function new(string name = "FIFO_normal_mode_sequence");
            super.new(name);
        endfunction

        task body;
            `uvm_info("run_phase", "FIFO constraint mode 'normal_mode_c' started", UVM_LOW);
            repeat (`TEST_ITER_MEDIUM) begin
                configure_seq_item();
                `enable_constraint (normal_mode_c)
                `disable_constraint (data_in_c)
                start_item(seq_item);
                assert(seq_item.randomize()) else $error("FIFO Randomization Failed for mode: normal_mode_c");
                finish_item(seq_item);
            end
        endtask

    endclass : FIFO_normal_mode_sequence

    class FIFO_read_only_sequence extends FIFO_base_sequence;

        `uvm_object_utils(FIFO_read_only_sequence)

        function new(string name = "FIFO_read_only_sequence");
            super.new(name);
        endfunction

        task body;
            `uvm_info("run_phase", "FIFO constraint mode 'read_only_c' started", UVM_LOW);
            repeat (`TEST_ITER_MEDIUM) begin
                configure_seq_item();
                `enable_constraint (read_only_c)
                start_item(seq_item);
                assert(seq_item.randomize()) else $error("FIFO Randomization Failed for mode: read_only_c");
                finish_item(seq_item);
            end
        endtask

    endclass : FIFO_read_only_sequence

    class FIFO_write_only_sequence extends FIFO_base_sequence;

        `uvm_object_utils(FIFO_write_only_sequence)

        function new(string name = "FIFO_write_only_sequence");
            super.new(name);
        endfunction

        task body;
            `uvm_info("run_phase", "FIFO constraint mode 'write_only_c' started", UVM_LOW);
            repeat (`TEST_ITER_MEDIUM) begin
                configure_seq_item();
                `enable_constraint (write_only_c)
                start_item(seq_item);
                assert(seq_item.randomize()) else $error("FIFO Randomization Failed for mode: write_only_c");
                finish_item(seq_item);
            end
        endtask

    endclass : FIFO_write_only_sequence

    class FIFO_write_ph_read_pl_sequence extends FIFO_base_sequence;

        `uvm_object_utils(FIFO_write_ph_read_pl_sequence)

        function new(string name = "FIFO_write_ph_read_pl_sequence");
            super.new(name);
        endfunction

        task body;
            `uvm_info("run_phase", "FIFO constraint mode 'write_ph_read_pl_c' started", UVM_LOW);
            repeat (`TEST_ITER_MEDIUM) begin
                configure_seq_item();
                `enable_constraint (write_ph_read_pl_c)
                start_item(seq_item);
                assert(seq_item.randomize()) else $error("FIFO Randomization Failed for mode: write_ph_read_pl_c");
                finish_item(seq_item);
            end
        endtask

    endclass : FIFO_write_ph_read_pl_sequence

    class FIFO_write_pl_read_ph_sequence extends FIFO_base_sequence;

        `uvm_object_utils(FIFO_write_pl_read_ph_sequence)

        function new(string name = "FIFO_write_pl_read_ph_sequence");
            super.new(name);
        endfunction

        task body;
            `uvm_info("run_phase", "FIFO constraint mode 'write_pl_read_ph_c' started", UVM_LOW);
            repeat (`TEST_ITER_MEDIUM) begin
                configure_seq_item();
                `enable_constraint (write_pl_read_ph_c)
                start_item(seq_item);
                assert(seq_item.randomize()) else $error("FIFO Randomization Failed for mode: write_pl_read_ph_c");
                finish_item(seq_item);
            end
        endtask

    endclass : FIFO_write_pl_read_ph_sequence

endpackage : FIFO_sequences_pkg