package uart_top_global_params_pkg;

    parameter   CLK_PERIOD        = `def_uart_rx_CLK_PERIOD;
    parameter   DATA_WIDTH        = `def_uart_DATA_WIDTH;
    parameter   PRESCALE_WIDTH    = `def_uart_rx_PRESCALE_WIDTH; //(4 times the speed of UART_TX prescale=4'b0100) or (8 times the speed of UART_TX prescale=4'b1000) 
    
endpackage: uart_top_global_params_pkg