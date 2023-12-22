class uart_tx_base_test extends  uvm_test;
  
    `uvm_component_utils(uart_tx_base_test)
  
    virtual uart_tx_system_if sys_if;
    
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
      `uvm_fatal("uart_tx_base_test", "Failed to get hmc_if")
      
      if(!uvm_config_db #(virtual uart_tx_system_if)::get(this, "","UART_TX_SYSTEM_IF", sys_if))
      `uvm_fatal("uart_tx_base_test", "Failed to get system_if")
  
      m_uart_tx_agent_cfg.active=UVM_ACTIVE ;

      m_uart_tx_env_cfg.m_uart_tx_agent_cfg=m_uart_tx_agent_cfg;
  
      uvm_config_db #(uart_tx_env_cfg)::set(this, "*", "m_uart_tx_env_cfg", m_uart_tx_env_cfg);
  
      m_uart_tx_env = uart_tx_env::type_id::create("m_uart_tx_env",this);
    endfunction : build_phase
  
    task run_phase(uvm_phase phase);
      sys_if.res_n  = 1'b1;
      #10ns;
      sys_if.res_n  = 1'b0;
      #240ns;
      //@(posedge sys_if.clk) 
      sys_if.res_n = 1'b1;    
    endtask : run_phase
  
  
    function void set_seqs(uart_tx_vseq_base seq);
      seq.m_cfg = m_uart_tx_env_cfg;
      seq.sys_if = sys_if;
    endfunction
  
    // Print Testbench structure and factory contents
    function void start_of_simulation_phase(uvm_phase phase);
      super.start_of_simulation_phase(phase);
      if (uvm_report_enabled(UVM_MEDIUM)) begin
        this.print();
        factory.print();
      end
    endfunction : start_of_simulation_phase
  
  
  endclass : uart_tx_base_test