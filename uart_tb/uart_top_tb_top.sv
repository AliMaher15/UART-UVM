`timescale 1ns/1ps

module uart_top_tb_top();

import uvm_pkg::*;
`include "uvm_macros.svh"
import uart_top_global_params_pkg::*;
import uart_top_tb_pkg::*;
import uart_top_test_pkg::*;

bit rx_clk;
bit tx_clk;
logic [PRESCALE_WIDTH-1:0]  prescale_tb ;

//************** INTERFACES INSTANTS ****************//
uart_top_system_if UART_TOP_SYSTEM_IF (.clk(tx_clk));

uart_rx_if #(.DATA_WIDTH(DATA_WIDTH)) UART_RX_IF (.rx_clk(rx_clk), .tx_clk(tx_clk), .res_n(UART_TOP_SYSTEM_IF.res_n), .prescale_in(prescale_tb));
uart_tx_if #(.DATA_WIDTH(DATA_WIDTH)) UART_TX_IF (.clk(tx_clk), .res_n(UART_TOP_SYSTEM_IF.res_n));
//***************************************************//

//**************** DUT INSTANTS *********************//
UART   #(.DATA_WIDTH(DATA_WIDTH),
          .PRESCALE_WIDTH(PRESCALE_WIDTH)   
         )
dut (
     .RST(UART_TOP_SYSTEM_IF.res_n)              , 
     //uart_tx inputs
     .TX_CLK(tx_clk)                             ,
     .TX_PAR_EN(UART_TX_IF.par_en)               ,
     .TX_PAR_TYP(UART_TX_IF.par_typ)             ,
     .TX_IN_P(UART_TX_IF.p_data)                 ,
     .TX_IN_V(UART_TX_IF.data_valid)             ,
     //uart_tx outputs
     .TX_OUT_S(UART_TX_IF.tx_out)                ,
     .TX_OUT_B(UART_TX_IF.busy)                  ,
     //uart_rx inputs
     .RX_CLK(rx_clk)                             ,
     .RX_PAR_EN(UART_RX_IF.par_en_in)            ,
     .RX_PAR_TYP(UART_RX_IF.par_typ_in)          ,
     .Prescale(UART_RX_IF.prescale_in)           , 
     .RX_IN_S(UART_RX_IF.s_data_in)              ,
     //uart_rx outputs
     .RX_OUT_P(UART_RX_IF.p_data_out)            ,
     .RX_OUT_V(UART_RX_IF.data_valid_out)        ,
     .RX_OUT_PAR_ERR(UART_RX_IF.parity_error_out),
     .RX_OUT_STP_ERR(UART_RX_IF.stop_error_out)
     );
//***************************************************//

//************** ASSERTIONS MODULE ******************//
bind UART_RX : dut.U0_UART_RX uart_rx_assertions #(.DATA_WIDTH(DATA_WIDTH),
                                         .PRESCALE_WIDTH(PRESCALE_WIDTH)
                                         )
                 uart_rx_sva (.*);

bind UART_TX : dut.U0_UART_TX uart_tx_assertions #(.DATA_WIDTH(DATA_WIDTH)) uart_tx_sva (.*);
//***************************************************// 

//***************** START TEST **********************//
// pass the interfaces handles then run the test
initial begin
    //            interface type                        access hierarchy            instance name
    uvm_config_db#(virtual uart_top_system_if)::set(null, "uvm_test_top", "UART_TOP_SYSTEM_IF", UART_TOP_SYSTEM_IF);
    

    uvm_config_db#(virtual uart_rx_if#(.DATA_WIDTH(DATA_WIDTH), .PRESCALE_WIDTH(PRESCALE_WIDTH)))::set(null, "uvm_test_top", "UART_RX_IF", UART_RX_IF);
    uvm_config_db#(virtual uart_tx_if#(.DATA_WIDTH(DATA_WIDTH)))::set(null, "uvm_test_top", "UART_TX_IF", UART_TX_IF);

    run_test();
end
//***************************************************// 

//***************** CLOCK ***************************//
initial begin
    rx_clk = 1;
    //prescale_tb = 'd4;
    prescale_tb = 'b1000 ;
    forever begin  
        #(CLK_PERIOD/2);  rx_clk = ~rx_clk;
    end
end
initial begin
    tx_clk = 1;
    forever begin
        #((CLK_PERIOD/2)*8);  tx_clk = ~tx_clk ;
    end 
end
//***************************************************// 

endmodule : uart_top_tb_top