class uart_rx_vseq_base extends  uvm_sequence#(uvm_sequence_item);
    `uvm_object_utils(uart_rx_vseq_base)
    `uvm_declare_p_sequencer(uart_rx_vsequencer)

    virtual uart_rx_system_if sys_if;
    uart_rx_env_cfg m_cfg;
  
    uart_rx_agent_seqr  m_uart_rx_seqr;
  
    function new(string name = "");
      super.new(name);
    endfunction : new
  
    
    virtual task body();
        m_cfg = p_sequencer.m_cfg ;
        if(m_cfg == null) begin
            `uvm_fatal("uart_rx_vseq_base", "env_config is null")
        end
        // assign all sequencers to their handle in vsequencer
        m_uart_rx_seqr = p_sequencer.m_uart_rx_agent_seqr;
    endtask : body

    function void seq_set_cfg(uart_rx_base_seq seq_);
        seq_.m_cfg = m_cfg;
        seq_.sys_if = sys_if;
    endfunction

    task activate_reset(string parent);
        `uvm_info(parent, "ENTER RESET MODE", UVM_MEDIUM)
          sys_if.res_n  <= 1'b0;
          #500ns;
          @(posedge sys_if.clk) 
          sys_if.res_n <= 1'b1;
        `uvm_info(parent, "EXIT RESET MODE", UVM_MEDIUM)
      endtask : activate_reset    
  
  endclass : uart_rx_vseq_base