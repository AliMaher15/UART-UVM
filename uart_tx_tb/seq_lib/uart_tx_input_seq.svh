class uart_tx_input_seq extends uart_tx_base_seq;
    `uvm_object_utils(uart_tx_input_seq);

    uart_tx_item input_item;

    //  Constructor: new
    function new(string name = "");
        super.new(name);
    endfunction: new

    extern virtual task body();
    
endclass: uart_tx_input_seq


task uart_tx_input_seq::body();
    input_item = uart_tx_item::type_id::create("input_item");
    //communicate with driver
    start_item(input_item);
    // randomize
    Randomize_Uart_TX_item: assert (input_item.randomize() with {});
    finish_item(input_item);
endtask