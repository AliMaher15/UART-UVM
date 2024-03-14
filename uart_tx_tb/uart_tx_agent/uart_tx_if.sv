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




//*****************************************************//
//***************** ASSERTIONS ************************//
//*****************************************************//
`define assert_clk(arg) \
  assert property (@(posedge clk) disable iff (!res_n) arg);

`define assert_async_rst(arg) \
  assert property (@(negedge res_n) 1'b1 |=> @(posedge clk) arg);

// Reset assertions
uart_tx_reset_assertion :
    `assert_async_rst(p_data==0 && data_valid==0 && par_en==0 && par_typ==0
                      && busy==0 && tx_out==0)

// Specs assertions
data_valid_high_1_clk :
    `assert_clk(data_valid |=> !data_valid)

s_data_high_during_idle :
    `assert_clk($fell(busy) |-> tx_out)

start_bit_low :
    `assert_clk($rose(busy) |-> $fell(tx_out))

busy_high_if_data_valid :
    `assert_clk(data_valid |=> ##[0:1] busy)
    
endinterface : uart_tx_if