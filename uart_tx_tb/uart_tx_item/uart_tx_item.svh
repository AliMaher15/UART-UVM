class uart_tx_item extends uvm_sequence_item;
    // Variables
    /// inputs to dut
    rand bit [DATA_WIDTH-1:0] p_data;
    rand bit par_en;
    rand bit par_typ;
    // dut outputs
    bit [DATA_WIDTH-1:0] tx_out;
    // control
    bit rst_op = 0;
    bit stop_bit = 1;
    bit start_bit = 0;
    bit parity_bit;

    // factory registeration
    `uvm_object_utils_begin(uart_tx_item)
        `uvm_field_int(p_data,     UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(stop_bit,   UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(parity_bit, UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(par_en,     UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(par_typ,    UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(start_bit,  UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(tx_out,     UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(rst_op,     UVM_DEFAULT | UVM_BIN)          
    `uvm_object_utils_end

    //  Group: Functions

    //  Constructor: new
    function new(string name = "");
        super.new(name);
    endfunction: new
    
endclass: uart_tx_item