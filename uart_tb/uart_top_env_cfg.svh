class uart_top_env_cfg extends uvm_object;

    `uvm_object_utils(uart_top_env_cfg);

    //  Variables
    // rand bit flag = 0;
    //  Constraints

    // uart_rx and uart_tx environments configurations
    uart_tx_env_cfg  m_uart_tx_env_cfg;
    uart_rx_env_cfg  m_uart_rx_env_cfg;

    //  Constructor: new
    function new(string name = "");
        super.new(name);
    endfunction: new
    
endclass: uart_top_env_cfg