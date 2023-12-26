package uart_rx_global_params_pkg;

    parameter   CLK_PERIOD        = 20;
    parameter   DATA_WIDTH        = 8;
    parameter   PRESCALE_WIDTH    = 5; //(4 times the speed of UART_TX prescale=4'b0100) or (8 times the speed of UART_TX prescale=4'b1000) 
    
endpackage: uart_rx_global_params_pkg