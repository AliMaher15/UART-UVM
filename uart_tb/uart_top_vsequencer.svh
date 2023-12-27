class uart_top_vsequencer extends uvm_sequencer;

    // register in factory
    `uvm_component_utils(uart_top_vsequencer)

    // the virtual sequencers of environments below
    uart_tx_vsequencer m_uart_tx_agent_seqr;
    uart_rx_vsequencer m_uart_rx_agent_seqr;
    // env config
    uart_top_env_cfg m_cfg;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        if(!uvm_config_db #(uart_top_env_cfg)::get(this, "","m_uart_top_env_cfg", m_cfg))
        `uvm_fatal(get_full_name(), "Failed to get uart_top_env_cfg from database")
    endfunction

endclass : uart_top_vsequencer