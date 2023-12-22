package uart_rx_agent_pkg;

    //uvm pakage and macros
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import uart_rx_item_pkg::*;

    `include "uart_rx_agent_cfg.svh"
    `include "uart_rx_monitor.svh"
    `include "uart_rx_agent_seqr.svh"
    `include "uart_rx_driver.svh"
    `include "uart_rx_agent.svh"
  
  
  endpackage : uart_rx_agent_pkg