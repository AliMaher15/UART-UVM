package uart_top_tb_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import uart_top_global_params_pkg::*;
 
    import uart_rx_tb_pkg::*;
    import uart_tx_tb_pkg::*;

    `include "uart_top_env_cfg.svh"
    `include "uart_top_vsequencer.svh"	
    `include "uart_top_env.svh"    

endpackage : uart_top_tb_pkg