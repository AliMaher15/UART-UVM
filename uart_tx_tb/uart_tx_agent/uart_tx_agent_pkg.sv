package uart_tx_agent_pkg;

    //uvm pakage and macros
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import uart_tx_item_pkg::*;

    `include "uart_tx_agent_cfg.svh"
    `include "uart_tx_monitor.svh"
    `include "uart_tx_agent_seqr.svh"
    `include "uart_tx_driver.svh"
    `include "uart_tx_agent.svh"
  
  
  endpackage : uart_tx_agent_pkg