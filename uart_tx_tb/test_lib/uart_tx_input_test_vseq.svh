class uart_tx_input_test_vseq extends uart_tx_vseq_base ;

    `uvm_object_utils(uart_tx_input_test_vseq)
  
    uart_tx_input_seq utx_in_seq_h ;
  
    function new(string name = "");
      super.new(name);
    endfunction : new
  
    task body();
  
      utx_in_seq_h=uart_tx_input_seq::type_id::create("utx_in_seq_h") ;
      seq_set_cfg(utx_in_seq_h);
     // start
      super.body();
        repeat(100) begin
          `uvm_info("uart_tx_input_test_vseq", "Executing sequence", UVM_HIGH)
            utx_in_seq_h.start(p_sequencer.m_uart_tx_agent_seqr);
          //#2us;
          `uvm_info("uart_tx_input_test_vseq", "Sequence complete", UVM_HIGH)
        end
    endtask : body
  
  endclass : uart_tx_input_test_vseq