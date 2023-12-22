class uart_rx_input_seq extends uart_rx_base_seq;
    `uvm_object_utils(uart_rx_input_seq);

    uart_rx_item input_item;

    //  Constructor: new
    function new(string name = "");
        super.new(name);
    endfunction: new

    extern virtual task body();
    
endclass: uart_rx_input_seq


task uart_rx_input_seq::body();
    input_item = uart_rx_item::type_id::create("input_item");
    //communicate with driver
    start_item(input_item);
    // randomize
    Randomize_Uart_RX_item: assert (input_item.randomize());
    finish_item(input_item);
endtask