class uart_tx_base_seq extends  uvm_sequence #(uvm_sequence_item);

    `uvm_object_utils(uart_tx_base_seq)
  
    uart_tx_env_cfg m_cfg;
  
    virtual uart_tx_system_if sys_if;
  
    function new(string name = "");
      super.new(name);
    endfunction : new
  
    task body();
      if(m_cfg == null) begin
        `uvm_fatal("uart_tx_base_seq", "env_config is null")
      end
    endtask : body
  
    task activate_reset(string parent);
      `uvm_info(parent, "ENTER RESET MODE", UVM_MEDIUM)
        sys_if.res_n  <= 1'b0;
        #500ns;
        @(posedge sys_if.clk) 
        sys_if.res_n <= 1'b1;
      `uvm_info(parent, "EXIT RESET MODE", UVM_MEDIUM)
    endtask : activate_reset
  
  endclass : uart_tx_base_seq
  
  
  