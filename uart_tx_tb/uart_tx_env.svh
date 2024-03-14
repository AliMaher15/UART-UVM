class uart_tx_env extends uvm_env;

    // register in factory 
    `uvm_component_utils(uart_tx_env)

//********** Declare Handles **********//    
    uart_tx_vsequencer  m_vseqr;
    uart_tx_env_cfg     m_cfg;
    uart_tx_agent_t     m_uart_tx_agent;
    uart_tx_scoreboard  m_scoreboard;
    uart_tx_coverage    m_coverage;
    
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction : new

    // Class Methods
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

endclass : uart_tx_env

function void uart_tx_env::build_phase(uvm_phase phase);

    // check configuration
    if(!uvm_config_db#(uart_tx_env_cfg)::get(this, "", "m_uart_tx_env_cfg", m_cfg))
        `uvm_fatal(get_full_name(), "Failed to get env_cfg from database")

    // path configuration to agents
    uvm_config_db#(uart_tx_agent_cfg_t)::set(this, "m_uart_tx_agent*", "uart_tx_agent_cfg_t", m_cfg.m_uart_tx_agent_cfg);
    
    // create objects
    m_uart_tx_agent = uart_tx_agent_t::type_id::create("m_uart_tx_agent",this);
    m_vseqr         = uart_tx_vsequencer::type_id::create("m_vseqr",this);
    m_scoreboard    = uart_tx_scoreboard::type_id::create("m_scoreboard",this);
    m_coverage      = uart_tx_coverage::type_id::create("m_coverage",this);
  
endfunction: build_phase


function void uart_tx_env::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // connect the virtual sequencer with the agent sequencer
    m_vseqr.m_uart_tx_agent_seqr = m_uart_tx_agent.m_seqr;

    // Connect Coverage and Scoreboard with monitor
    m_uart_tx_agent.uart_tx_input_ap.connect(m_coverage.analysis_export);
    m_uart_tx_agent.uart_tx_input_ap.connect(m_scoreboard.axp_in);
    m_uart_tx_agent.uart_tx_output_ap.connect(m_scoreboard.axp_out);
endfunction: connect_phase
