interface uart_rx_if #(DATA_WIDTH = 8, PRESCALE_WIDTH = 5)
                      (
                        input rx_clk,
                        input tx_clk,
                        input res_n,
                        input [PRESCALE_WIDTH-1:0]  prescale_in
                      );

// Interface Inputs to uart_rx
logic                       s_data_in;
logic                       par_en_in;
logic                       par_typ_in;
// uart_rx outputs to interface
logic                       data_valid_out;
logic                       parity_error_out;
logic                       stop_error_out;
logic [DATA_WIDTH-1:0]      p_data_out; // serialized output
    
endinterface : uart_rx_if