class uart_tx_base_seq extends  uvm_sequence #(uvm_sequence_item);

    `uvm_object_utils(uart_tx_base_seq)
  
    uart_tx_env_cfg m_cfg;
  
  
    function new(string name = "");
      super.new(name);
    endfunction : new
  
    task body();
      if(m_cfg == null) begin
        `uvm_fatal("uart_tx_base_seq", "env_config is null")
      end
    endtask : body
  
  
  endclass : uart_tx_base_seq
  
  
  