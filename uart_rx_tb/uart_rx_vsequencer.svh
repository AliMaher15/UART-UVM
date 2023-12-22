class uart_rx_vsequencer extends uvm_sequencer;

    // register in factory
    `uvm_component_utils(uart_rx_vsequencer)

    // contains the following sequencers
    uart_rx_agent_seqr m_uart_rx_agent_seqr;
    // env config
    uart_rx_env_cfg m_cfg;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
       if(!uvm_config_db #(uart_rx_env_cfg)::get(this, "","m_uart_rx_env_cfg", m_cfg))
       `uvm_fatal(get_full_name(), "Failed to get uart_rx_env_cfg from database")
    endfunction

endclass : uart_rx_vsequencer