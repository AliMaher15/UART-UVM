package uart_rx_usertypes_pkg;

    import uart_rx_global_params_pkg::*;
    import uart_rx_agent_pkg::*;

    typedef uart_rx_agent_cfg #(.DATA_WIDTH(DATA_WIDTH), .PRESCALE_WIDTH(PRESCALE_WIDTH)) uart_rx_agent_cfg_t;
    typedef uart_rx_agent     #(.DATA_WIDTH(DATA_WIDTH), .PRESCALE_WIDTH(PRESCALE_WIDTH)) uart_rx_agent_t;
    typedef virtual uart_rx_if#(.DATA_WIDTH(DATA_WIDTH), .PRESCALE_WIDTH(PRESCALE_WIDTH)) uart_rx_if_t;
    
endpackage: uart_rx_usertypes_pkg