interface uart_rx_if #(DATA_WIDTH = 8, PRESCALE_WIDTH = 4)
                      (
                        input clk,
                        input res_n
                      );

// Interface Inputs to uart_tx
logic                       s_data_in;
logic [PRESCALE_WIDTH-1:0]  prescale_in;
logic                       par_en_in;
logic                       par_typ_in;
// uart_tx outputs to interface
logic                       data_valid_out;
logic                       parity_error_out;
logic                       stop_error_out;
logic [DATA_WIDTH-1:0]      p_data_out; // serialized output
    
endinterface : uart_rx_if