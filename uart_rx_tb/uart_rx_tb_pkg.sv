package uart_rx_tb_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
 
    import uart_rx_item_pkg::*;
    import uart_rx_agent_pkg::*;
    import uart_rx_params_pkg::*;

    `include "uart_rx_checkers/uart_rx_coverage.svh"
    `include "uart_rx_checkers/uart_rx_scoreboard.svh"
    `include "uart_rx_env_cfg.svh"
    `include "uart_rx_vsequencer.svh"	
    `include "uart_rx_env.svh"    

endpackage : uart_rx_tb_pkg