package uart_tx_tb_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
 
    import uart_tx_item_pkg::*;
    import uart_tx_agent_pkg::*;
    import uart_tx_global_params_pkg::*;
    import uart_tx_usertypes_pkg::*;

    `include "uart_tx_checkers/uart_tx_coverage.svh"
    `include "uart_tx_checkers/uart_tx_scoreboard.svh"
    `include "uart_tx_env_cfg.svh"
    `include "uart_tx_vsequencer.svh"	
    `include "uart_tx_env.svh"    

endpackage : uart_tx_tb_pkg