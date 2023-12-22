// I dont know how to deal with parameters 
// in a sequence item
class uart_rx_item extends uvm_sequence_item;

    // Variables
    /// inputs to dut
    rand bit [DATA_WIDTH-1:0] s_data_in; // randomize all at once and handle serialization in driver/monitor
    rand bit par_en_in;
    rand bit par_typ_in;
    // dut outputs
    rand bit data_valid_out;
    rand bit parity_error_out;
    rand bit stop_error_out;
    rand bit [DATA_WIDTH-1:0] p_data_out;

    //configurations
    rand bit insert_parity_error;
    rand bit insert_stop_error;

    // automatic copy, compare and the default functions..
    `uvm_object_utils_begin(uart_rx_item)
        `uvm_field_int(s_data_in       , UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(par_en_in       , UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(par_typ_in      , UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(data_valid_out  , UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(parity_error_out, UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(stop_error_out  , UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(p_data_out      , UVM_DEFAULT | UVM_BIN)       
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
    
endclass: uart_rx_item


/*----------------------------------------------------------------------------*/
/*  Constraints                                                               */
/*----------------------------------------------------------------------------*/




/*----------------------------------------------------------------------------*/
/*  Functions                                                                 */
/*----------------------------------------------------------------------------*/

