class uart_top_env extends uvm_env;

    // register in factory 
    `uvm_component_utils(uart_top_env)

//********** Declare Handles **********//    
    uart_top_vsequencer  m_vseqr;
    uart_top_env_cfg    m_cfg;
    uart_tx_env         m_uart_tx_env;
    uart_rx_env         m_uart_rx_env;
    
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction : new

    // Class Methods
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

endclass : uart_top_env

function void uart_top_env::build_phase(uvm_phase phase);

    // check configuration
    if(!uvm_config_db#(uart_top_env_cfg)::get(this, "", "m_uart_top_env_cfg", m_cfg))
        `uvm_fatal(get_full_name(), "Failed to get configuration from database")

    // path configuration to environments below
    uvm_config_db#(uart_tx_env_cfg)::set(this, "m_uart_tx_env*", "m_uart_tx_env_cfg", m_cfg.m_uart_tx_env_cfg);
    uvm_config_db#(uart_rx_env_cfg)::set(this, "m_uart_rx_env*", "m_uart_rx_env_cfg", m_cfg.m_uart_rx_env_cfg);
    
    // create objects
    m_uart_tx_env = uart_tx_env::type_id::create("m_uart_tx_env",this);
    m_uart_rx_env = uart_rx_env::type_id::create("m_uart_rx_env",this);
    m_vseqr       = uart_top_vsequencer::type_id::create("m_vseqr",this);
  
endfunction: build_phase


function void uart_top_env::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // connect the virtual sequencer with the environments virtual sequencers
    m_vseqr.m_uart_tx_agent_seqr = m_uart_tx_env.m_vseqr;
    m_vseqr.m_uart_rx_agent_seqr = m_uart_rx_env.m_vseqr;
    
endfunction: connect_phase
