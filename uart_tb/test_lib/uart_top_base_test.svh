class uart_top_base_test extends  uvm_test;
  
    `uvm_component_utils(uart_top_base_test)
  
    virtual uart_top_system_if sys_if;
    
    uart_rx_agent_cfg_t  m_uart_rx_agent_cfg;
    uart_tx_agent_cfg_t  m_uart_tx_agent_cfg;

    virtual uart_rx_if_t uart_rx_if;
    virtual uart_tx_if_t uart_tx_if;
  
    uart_rx_env_cfg m_uart_rx_env_cfg;
    uart_tx_env_cfg m_uart_tx_env_cfg;

    uart_top_env_cfg m_uart_top_env_cfg;
    uart_top_env     m_uart_top_env;
    
  
    function new(string name, uvm_component parent);
      super.new(name,parent);
    endfunction : new
  
  
    function void build_phase(uvm_phase phase);

      m_uart_top_env_cfg = uart_top_env_cfg::type_id::create("m_uart_top_env_cfg");
  
      //***************************************************************************************************//
      m_uart_rx_env_cfg = uart_rx_env_cfg::type_id::create("m_uart_rx_env_cfg");
      m_uart_rx_agent_cfg = uart_rx_agent_cfg_t::type_id::create("m_uart_rx_agent_cfg");
  
      if(!uvm_config_db#(uart_rx_if_t)::get(this, "","UART_RX_IF",  m_uart_rx_agent_cfg.vif))
        `uvm_fatal(get_full_name(), "Failed to get uart_rx_agent_cfg")
  
      m_uart_rx_agent_cfg.active=UVM_ACTIVE;

      m_uart_rx_env_cfg.m_uart_rx_agent_cfg=m_uart_rx_agent_cfg;

      //***************************************************************************************************//
      m_uart_tx_env_cfg = uart_tx_env_cfg::type_id::create("m_uart_tx_env_cfg");
      m_uart_tx_agent_cfg = uart_tx_agent_cfg_t::type_id::create("m_uart_tx_agent_cfg") ;
  
      if(!uvm_config_db#(uart_tx_if_t)::get(this, "","UART_TX_IF",  m_uart_tx_agent_cfg.vif))
        `uvm_fatal(get_full_name(), "Failed to get hmc_if")
  
      m_uart_tx_agent_cfg.active=UVM_ACTIVE ;

      m_uart_tx_env_cfg.m_uart_tx_agent_cfg=m_uart_tx_agent_cfg;
      
      //***************************************************************************************************//
      m_uart_top_env_cfg.m_uart_rx_env_cfg=m_uart_rx_env_cfg;
      m_uart_top_env_cfg.m_uart_tx_env_cfg=m_uart_tx_env_cfg;

      if(!uvm_config_db#(virtual uart_top_system_if)::get(this, "","UART_TOP_SYSTEM_IF", sys_if))
        `uvm_fatal(get_full_name(), "Failed to get system_if")

      uvm_config_db#(uart_top_env_cfg)::set(this, "*", "m_uart_top_env_cfg", m_uart_top_env_cfg);
  
      m_uart_top_env = uart_top_env::type_id::create("m_uart_top_env",this);
    endfunction : build_phase
  
    task run_phase(uvm_phase phase);
      //sys_if.res_n  = 1'b1; // deactivate
      //#10ns;
      sys_if.res_n  = 1'b0; // activate
      #70ns;
      //@(posedge sys_if.clk) 
      sys_if.res_n = 1'b1;    
    endtask : run_phase
  
  
    function void set_seqs(uart_top_vseq_base seq);
      seq.m_cfg = m_uart_top_env_cfg;
    endfunction
  
    // Print Testbench structure and factory contents
    function void start_of_simulation_phase(uvm_phase phase);
      super.start_of_simulation_phase(phase);
      if (uvm_report_enabled(UVM_MEDIUM)) begin
        this.print();
        factory.print();
      end
    endfunction : start_of_simulation_phase
  
  
  endclass : uart_top_base_test