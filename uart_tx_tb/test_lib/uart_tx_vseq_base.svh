class uart_tx_vseq_base extends  uvm_sequence#(uvm_sequence_item);
    `uvm_object_utils(uart_tx_vseq_base)
    `uvm_declare_p_sequencer(uart_tx_vsequencer)

    uart_tx_env_cfg m_cfg;
  
  
    function new(string name = "");
      super.new(name);
    endfunction : new
  
    
    virtual task body();
        m_cfg = p_sequencer.m_cfg ;
        if(m_cfg == null) begin
            `uvm_fatal("uart_tx_vseq_base", "env_config is null")
        end
    endtask : body

    function void seq_set_cfg(uart_tx_base_seq seq_);
        seq_.m_cfg = m_cfg;
    endfunction
   
  
  endclass : uart_tx_vseq_base