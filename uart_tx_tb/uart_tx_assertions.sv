module uart_tx_assertions #(
    parameter DATA_WIDTH = 8
) (
    input   wire    [DATA_WIDTH-1:0]   P_DATA      ,
    input   wire                       Data_Valid  ,
    input   wire                       PAR_EN      , 
    input   wire                       PAR_TYP     ,
    input   wire                       CLK         , 
    input   wire                       RST         ,
    output  wire                       Busy        ,
    output  wire                       TX_OUT
);

//********* MACROS FUNCTIONS ***********//
`define assert_clk(arg) \
  assert property (@(posedge CLK) disable iff (!RST) arg);

/* Handles case of rst_n going to zero
ap_async_rst: assert property(@(negedge rst_n) 1'b1 |=>  @(posedge clk) ptr==0 && cnt==0);
// Handles case of powerup, when clk goes live 
// changed the |-> to |=>
ap_sync_rst: assert property(@(posedge clk) !rst_n |=>  ptr==0 && cnt==0);*/
`define assert_async_rst(arg) \
  assert property (@(negedge RST) 1'b1 |=> @(posedge CLK) arg);

//*************** ASSERTIONS ******************//

// Reset assertions
uart_tx_reset_assertion :
    `assert_async_rst(P_DATA==0 && Data_Valid==0 && PAR_EN==0 && PAR_TYP==0
                      && Busy==0 && TX_OUT==0)

// Specs assertions
data_valid_high_1_clk :
    `assert_clk(Data_Valid |=> !Data_Valid)

s_data_high_during_idle :
    `assert_clk(##1 !Busy |-> TX_OUT)

busy_high_if_data_valid :
    `assert_clk(Data_Valid |=> ##[0:1] Busy)
    
endmodule