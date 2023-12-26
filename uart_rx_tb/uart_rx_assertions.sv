module uart_rx_assertions #( parameter DATA_WIDTH = 8, 
                                       PRESCALE_WIDTH = 5   // 32 or 16 or 8 or 4
                           )
(
input   wire                            CLK     ,
input   wire                            RST     ,
input   wire                            RX_IN   ,
input   wire    [PRESCALE_WIDTH-1:0]    Prescale,
input   wire                            parity_enable  ,
input   wire                            parity_type ,
output  wire    [DATA_WIDTH-1:0]        P_DATA  ,
output  wire                            par_err ,
output  wire                            stp_err ,
output  wire                            data_valid
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
uart_rx_reset_assertion :
    `assert_async_rst(P_DATA==0 && data_valid==0 && parity_enable==0 && parity_type==0
                      && RX_IN==0 && par_err==0 &&  stp_err==0)

// Specs assertions

    
endmodule