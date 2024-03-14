class uart_tx_input_test_vseq extends uart_tx_vseq_base ;

    `uvm_object_utils(uart_tx_input_test_vseq)
  
    uart_tx_input_seq utx_in_seq_h ;
    uart_tx_input_constr_seq utx_in_constr_seq_h ;
  
    function new(string name = "");
      super.new(name);
    endfunction : new
  
    task body();
  
      utx_in_seq_h=uart_tx_input_seq::type_id::create("utx_in_seq_h") ;
      utx_in_constr_seq_h=uart_tx_input_constr_seq::type_id::create("utx_in_constr_seq_h") ;
      seq_set_cfg(utx_in_seq_h);
      seq_set_cfg(utx_in_constr_seq_h);
     // start
      super.body();
        repeat(50) begin
          `uvm_info(get_type_name(), "Executing normal sequence", UVM_HIGH)
            utx_in_seq_h.start(p_sequencer.m_uart_tx_agent_seqr);
          `uvm_info(get_type_name(), "Sequence normal complete", UVM_HIGH)
        end
        repeat(50) begin
          `uvm_info(get_type_name(), "Executing constrained sequence", UVM_HIGH)
          utx_in_constr_seq_h.start(p_sequencer.m_uart_tx_agent_seqr);
          `uvm_info(get_type_name(), "Sequence constrained complete", UVM_HIGH)
        end
    endtask : body
  
  endclass : uart_tx_input_test_vseq