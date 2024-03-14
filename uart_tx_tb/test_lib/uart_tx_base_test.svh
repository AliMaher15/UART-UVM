class uart_tx_base_test extends  uvm_test;
  
    `uvm_component_utils(uart_tx_base_test)
  
    // Reset Driver
    rst_driver_c                      m_rst_drv;
    
    uart_tx_agent_cfg_t  m_uart_tx_agent_cfg;
    virtual uart_tx_if_t uart_tx_if;
  
    uart_tx_env_cfg m_uart_tx_env_cfg;
    uart_tx_env     m_uart_tx_env;
    
  
    function new(string name, uvm_component parent);
      super.new(name,parent);
    endfunction : new
  
  
    function void build_phase(uvm_phase phase);
  
      m_uart_tx_env_cfg = uart_tx_env_cfg::type_id::create ("m_uart_tx_env_cfg");
      m_uart_tx_agent_cfg = uart_tx_agent_cfg_t::type_id::create("m_uart_tx_agent_cfg") ;
  
      if(!uvm_config_db #(uart_tx_if_t)::get(this, "","UART_TX_IF",  m_uart_tx_agent_cfg.vif))
      `uvm_fatal("uart_tx_base_test", "Failed to get uart_tx_if")
  
      m_uart_tx_agent_cfg.active=UVM_ACTIVE ;

      m_uart_tx_env_cfg.m_uart_tx_agent_cfg=m_uart_tx_agent_cfg;
  
      uvm_config_db #(uart_tx_env_cfg)::set(this, "*", "m_uart_tx_env_cfg", m_uart_tx_env_cfg);
  
      m_uart_tx_env = uart_tx_env::type_id::create("m_uart_tx_env",this);

      // Reset Handling
      m_rst_drv = rst_driver_c::type_id::create("m_rst_drv", this);
      uvm_config_db#(string)::set(this, "m_rst_drv", "intf_name", "rst_i");
      m_rst_drv.randomize();
    endfunction : build_phase
  
  
    function void set_seqs(uart_tx_vseq_base seq);
      seq.m_cfg = m_uart_tx_env_cfg;
    endfunction
  
    // Print Testbench structure and factory contents
    function void start_of_simulation_phase(uvm_phase phase);
      super.start_of_simulation_phase(phase);
      if (uvm_report_enabled(UVM_MEDIUM)) begin
        this.print();
        factory.print();
      end
    endfunction : start_of_simulation_phase

    task shutdown_phase(uvm_phase phase);
      phase.raise_objection(this);
      `uvm_info(get_name(), "<shutdown_phase> started, objection raised.", UVM_NONE)
    
      #500ns;
    
      phase.drop_objection(this);
      `uvm_info(get_name(), "<shutdown_phase> finished, objection dropped.", UVM_NONE)
    endtask: shutdown_phase
  
  endclass : uart_tx_base_test