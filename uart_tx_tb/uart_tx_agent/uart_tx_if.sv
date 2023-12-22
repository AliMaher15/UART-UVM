interface uart_tx_if #(DATA_WIDTH = 8)
                      (
                        input clk,
                        input res_n
                      );

// Interface Inputs to uart_tx
logic [DATA_WIDTH-1:0] p_data;
logic                  data_valid;
logic                  par_en;
logic                  par_typ;
// uart_tx outputs to interface
logic                  busy;
logic                  tx_out; // serialized output
    
endinterface : uart_tx_if