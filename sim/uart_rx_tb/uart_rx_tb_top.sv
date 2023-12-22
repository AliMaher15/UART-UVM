`timescale 1ns/1ps

module uart_rx_tb_top();

import uvm_pkg::*;
`include "uvm_macros.svh"
import uart_rx_global_params_pkg::*;
import uart_rx_usertypes_pkg::*;
import uart_rx_tb_pkg::*;
import uart_rx_seq_pkg::*;
import uart_rx_test_pkg::*;

bit clk;
bit slow_clk;
logic [PRESCALE_WIDTH-1:0]  prescale_tb ;

//************** INTERFACES INSTANTS ****************//
uart_rx_system_if UART_RX_SYSTEM_IF (.clk(clk));

uart_rx_if #(.DATA_WIDTH(DATA_WIDTH)) UART_RX_IF (.clk(clk), .res_n(UART_RX_SYSTEM_IF.res_n), .prescale_in(prescale_tb));
//***************************************************//

//**************** DUT INSTANTS *********************//
UART_RX #(.DATA_WIDTH(DATA_WIDTH),
          .PRESCALE_WIDTH(PRESCALE_WIDTH),
          .BIT_COUNTER_WIDTH(BIT_COUNTER_WIDTH))
dut (.CLK(clk),
     .RST(UART_TX_SYSTEM_IF.res_n),
     //uart_rx interface inputs to dut
     .RX_IN(UART_RX_IF.s_data_in),
     .Prescale(UART_RX_IF.prescale_in),
     .PAR_EN(UART_RX_IF.par_en_in),
     .PAR_TYP(UART_RX_IF.par_typ_in),
     //dut outputs to interface
     .P_DATA(UART_RX_IF.p_data_out),
     .data_valid(UART_RX_IF.data_valid_out),
     .par_err(UART_RX_IF.parity_error_out),
     .stp_err(UART_RX_IF.stop_error_out)
     );
//***************************************************//

//************** ASSERTIONS MODULE ******************//
 bind UART_RX : dut uart_rx_assertions #(.DATA_WIDTH(DATA_WIDTH),
                                         .PRESCALE_WIDTH(PRESCALE_WIDTH),
                                         .BIT_COUNTER_WIDTH(BIT_COUNTER_WIDTH))
                 uart_rx_sva (.*);
//***************************************************// 

//***************** START TEST **********************//
// pass the interfaces handles then run the test
initial begin
    //            interface type                        access hierarchy            instance name
    uvm_config_db#(virtual uart_rx_system_if)::set(null, "uvm_test_top", "UART_RX_SYSTEM_IF", UART_RX_SYSTEM_IF);

    uvm_config_db#(virtual uart_rx_if#(.DATA_WIDTH(DATA_WIDTH)), .PRESCALE_WIDTH(PRESCALE_WIDTH))::set(null, "uvm_test_top", "UART_RX_IF", UART_RX_IF);

    run_test();
end
//***************************************************// 

//***************** CLOCK ***************************//
initial begin
    clk = 0;
    prescale_tb = 'd4;
    forever begin  
        #(CLK_PERIOD/2);  clk = ~clk;
    end
end
initial begin
    slow_clk = 0;
    forever begin
        #40  slow_clk = ~slow_clk ;
    end 
end
//***************************************************// 

endmodule : uart_rx_tb_top