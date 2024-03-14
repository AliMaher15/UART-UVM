module uart_tx_tb_top();

import uvm_pkg::*;
`include "uvm_macros.svh"
import uart_tx_global_params_pkg::*;
import uart_tx_usertypes_pkg::*;
import uart_tx_tb_pkg::*;
import uart_tx_seq_pkg::*;
import uart_tx_test_pkg::*;

logic clk;

//************** INTERFACES INSTANTS ****************//
rst_intf rst_i ();

uart_tx_if #(.DATA_WIDTH(DATA_WIDTH)) UART_TX_IF (.clk(clk), .res_n(rst_i.res_n));
//***************************************************//

//**************** DUT INSTANTS *********************//
UART_TX #(.DATA_WIDTH(DATA_WIDTH))
dut (.CLK(clk),
     .RST(rst_i.res_n),
     //uart_tx interface inputs to dut
     .P_DATA(UART_TX_IF.p_data),
     .Data_Valid(UART_TX_IF.data_valid),
     .PAR_EN(UART_TX_IF.par_en),
     .PAR_TYP(UART_TX_IF.par_typ),
     //dut outputs to interface
     .Busy(UART_TX_IF.busy),
     .TX_OUT(UART_TX_IF.tx_out)
     );
//***************************************************//

//***************** START TEST **********************//
// pass the interfaces handles then run the test
initial begin
    $timeformat(-9,3," ns");
    
    //            interface type                        access hierarchy            instance name
    uvm_resource_db#(virtual rst_intf)::set("rst_intf", "rst_i", rst_i);
    uvm_config_db#(virtual uart_tx_if#(.DATA_WIDTH(DATA_WIDTH)))::set(null, "uvm_test_top", "UART_TX_IF", UART_TX_IF);

    run_test();
end
//***************************************************// 

//***************** CLOCK ***************************//
initial begin
    clk = 0;
    forever begin  
        #(CLK_PERIOD/2);  clk = ~clk;    
    end
end
//***************************************************// 

endmodule : uart_tx_tb_top