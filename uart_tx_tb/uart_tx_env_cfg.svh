class uart_tx_env_cfg extends uvm_object;

    `uvm_object_utils(uart_tx_env_cfg);

    //  Variables
    // rand bit flag = 0;
    //  Constraints

    // agents configurations
    uart_tx_agent_cfg_t  m_uart_tx_agent_cfg;

    //  Constructor: new
    function new(string name = "");
        super.new(name);
    endfunction: new
    
endclass: uart_tx_env_cfg