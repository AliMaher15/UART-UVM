class uart_rx_env extends uvm_env;

    // register in factory 
    `uvm_component_utils(uart_rx_env)

//********** Declare Handles **********//    
    uart_rx_vsequencer  m_vseqr;
    uart_rx_env_cfg     m_cfg;
    uart_rx_agent_t     m_uart_rx_agent;
    uart_rx_scoreboard  m_scoreboard;
    uart_rx_coverage    m_coverage;
    
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction : new

    // Class Methods
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

endclass : uart_rx_env

function void uart_rx_env::build_phase(uvm_phase phase);

    // check configuration
    if(!uvm_config_db#(uart_rx_env_cfg)::get(this, "", "m_uart_rx_env_cfg", m_cfg))
        `uvm_fatal("uart_rx_env", "Failed to get uart_rx_env_cfg from database")

    // path configuration to agents
    uvm_config_db#(uart_rx_agent_cfg_t)::set(this, "m_uart_rx_agent*", "uart_rx_agent_cfg_t", m_cfg.m_uart_rx_agent_cfg);
    
    // create objects
    m_uart_rx_agent = uart_rx_agent_t::type_id::create("m_uart_rx_agent",this);
    m_vseqr         = uart_rx_vsequencer::type_id::create("m_vseqr",this);
    m_scoreboard    = uart_rx_scoreboard::type_id::create("m_scoreboard",this);
    m_coverage      = uart_rx_coverage::type_id::create("m_coverage",this);
  
endfunction: build_phase


function void uart_rx_env::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // connect the virtual sequencer with the agent sequencer
    m_vseqr.m_uart_rx_agent_seqr = m_uart_rx_agent.m_seqr;

    // Connect Coverage and Scoreboard with monitor
    m_uart_rx_agent.uart_rx_input_ap.connect(m_coverage.analysis_export);
    m_uart_rx_agent.uart_rx_output_ap.connect(m_scoreboard.uart_rx_out_imp);
endfunction: connect_phase
