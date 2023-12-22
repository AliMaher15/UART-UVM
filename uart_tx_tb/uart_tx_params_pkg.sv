package uart_tx_params_pkg;

    import uart_tx_agent_pkg::*;

    parameter DATA_WIDTH = 8;

    typedef uart_tx_agent_cfg #(.DATA_WIDTH(DATA_WIDTH)) uart_tx_agent_cfg_t;
    typedef uart_tx_agent     #(.DATA_WIDTH(DATA_WIDTH)) uart_tx_agent_t;
    typedef virtual uart_tx_if#(.DATA_WIDTH(DATA_WIDTH)) uart_tx_if_t;
    
endpackage: uart_tx_params_pkg