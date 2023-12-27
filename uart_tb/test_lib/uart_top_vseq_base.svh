class uart_top_vseq_base extends  uvm_sequence#(uvm_sequence_item);
    `uvm_object_utils(uart_top_vseq_base)
    `uvm_declare_p_sequencer(uart_top_vsequencer)

    uart_top_env_cfg m_cfg;
  
  
    function new(string name = "");
      super.new(name);
    endfunction : new
  
    
    virtual task body();
        m_cfg = p_sequencer.m_cfg ;
        if(m_cfg == null) begin
            `uvm_fatal(get_full_name(), "uart_top_env_cfg is null")
        end
    endtask : body

    function void uart_rx_seq_set_cfg(uart_rx_base_seq seq_);
        seq_.m_cfg = m_cfg.m_uart_rx_env_cfg;
    endfunction

    function void uart_tx_seq_set_cfg(uart_tx_base_seq seq_);
        seq_.m_cfg = m_cfg.m_uart_tx_env_cfg;
    endfunction
  
  endclass : uart_top_vseq_base