class uart_rx_agent#(DATA_WIDTH = 8, PRESCALE_WIDTH = 4) extends uvm_agent;

    `uvm_component_param_utils(uart_rx_agent#(DATA_WIDTH, PRESCALE_WIDTH))

    uart_rx_agent_cfg #(DATA_WIDTH, PRESCALE_WIDTH) m_cfg;
    uart_rx_driver#(DATA_WIDTH, PRESCALE_WIDTH)     m_driver;
    uart_rx_monitor#(DATA_WIDTH, PRESCALE_WIDTH)    m_monitor;
    uart_rx_agent_seqr            m_seqr;

    uvm_analysis_port #(uart_rx_item) uart_rx_input_ap;
    uvm_analysis_port #(uart_rx_item) uart_rx_output_ap;
    
    function new(string name, uvm_component parent);
        super.new(name,parent);
        uart_rx_input_ap = new("uart_rx_input_ap", this);
        uart_rx_output_ap = new("uart_rx_output_ap", this);
    endfunction : new

    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);
    //  Function: connect_phase
    extern function void connect_phase(uvm_phase phase);
    
endclass : uart_rx_agent

function void uart_rx_agent::build_phase(uvm_phase phase);
    // check configuration
    if(!uvm_config_db#(uart_rx_agent_cfg #(DATA_WIDTH, PRESCALE_WIDTH))::get(this, "", "uart_rx_agent_cfg_t", m_cfg))
        `uvm_fatal("uart_rx_agent", "Failed to get uart_rx_agent_cfg_t from database")

    m_monitor = uart_rx_monitor#(DATA_WIDTH, PRESCALE_WIDTH)::type_id::create("m_monitor",this);
    m_monitor.m_cfg = m_cfg;

    if (m_cfg.active == UVM_ACTIVE) begin
        m_seqr = uart_rx_agent_seqr::type_id::create("m_seqr", this);
        m_driver = uart_rx_driver#(DATA_WIDTH, PRESCALE_WIDTH)::type_id::create("m_driver",this);
        m_driver.m_cfg = m_cfg;
    end
    
endfunction: build_phase

function void uart_rx_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    m_monitor.input_ap.connect(uart_rx_input_ap);
    m_monitor.output_ap.connect(uart_rx_output_ap);

    if (m_cfg.active == UVM_ACTIVE) begin
        m_driver.seq_item_port.connect(m_seqr.seq_item_export);
    end
    
endfunction: connect_phase
