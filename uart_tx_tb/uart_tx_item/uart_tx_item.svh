class uart_tx_item extends uvm_sequence_item;

    parameter data_width = 8;
    // Variables
    /// inputs to dut
    rand bit [data_width-1:0] p_data;
    rand bit data_valid;
    rand bit par_en;
    rand bit par_typ;
    // dut outputs
    rand bit busy;
    rand bit tx_out;

    // automatic copy, compare and the default functions..
    `uvm_object_utils_begin(uart_tx_item)
        `uvm_field_int(p_data,     UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(data_valid, UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(par_en,     UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(par_typ,    UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(busy,       UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(tx_out,     UVM_DEFAULT | UVM_BIN)    
    `uvm_object_utils_end

    // Constraints
    //  Constraint: 
    //extern constraint ;

    //  Group: Functions

    //  Constructor: new
    function new(string name = "");
        super.new(name);
    endfunction: new

    //  Function: do_copy
    // extern function void do_copy(uvm_object rhs);
    //  Function: do_compare
    // extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    //  Function: convert2string
    // extern function string convert2string();
    //  Function: do_print
    // extern function void do_print(uvm_printer printer);
    //  Function: do_record
    // extern function void do_record(uvm_recorder recorder);
    //  Function: do_pack
    // extern function void do_pack();
    //  Function: do_unpack
    // extern function void do_unpack();
    
endclass: uart_tx_item


/*----------------------------------------------------------------------------*/
/*  Constraints                                                               */
/*----------------------------------------------------------------------------*/




/*----------------------------------------------------------------------------*/
/*  Functions                                                                 */
/*----------------------------------------------------------------------------*/

