package uart_top_test_pkg ;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import uart_top_global_params_pkg::*;
    import uart_rx_usertypes_pkg::*;
    import uart_tx_usertypes_pkg::*;

    import uart_rx_seq_pkg::*;
    import uart_tx_seq_pkg::*;

    import uart_rx_tb_pkg::*;
    import uart_tx_tb_pkg::*;
    import uart_top_tb_pkg::*;

    `include "uart_top_vseq_base.svh"    
    `include "uart_top_base_test.svh"

    `include "uart_top_simple_test_vseq.svh"
    `include "uart_top_simple_test.svh"

endpackage : uart_top_test_pkg