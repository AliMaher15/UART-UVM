class uart_top_simple_test_vseq extends uart_top_vseq_base ;

    `uvm_object_utils(uart_top_simple_test_vseq)
  
    uart_rx_input_seq   urx_in_seq_h ;
    uart_tx_input_seq   utx_in_seq_h ;
  
    function new(string name = "");
      super.new(name);
    endfunction : new
  
    task body();
  
      urx_in_seq_h=uart_rx_input_seq::type_id::create("urx_in_seq_h") ;
      uart_rx_seq_set_cfg(urx_in_seq_h);

      utx_in_seq_h=uart_tx_input_seq::type_id::create("utx_in_seq_h") ;
      uart_tx_seq_set_cfg(utx_in_seq_h);
     // start
      super.body();
      fork
        begin
          repeat(50) begin
            `uvm_info(get_full_name(), "Executing uart_tx_input_seq", UVM_HIGH)
              utx_in_seq_h.start(p_sequencer.m_uart_tx_agent_seqr.m_uart_tx_agent_seqr);
            //#2us;
            `uvm_info(get_full_name(), "uart_tx_input_seq Sequence complete", UVM_HIGH)
          end
        end
        
        begin
          repeat(50) begin
            `uvm_info(get_full_name(), "Executing uart_rx_input_seq", UVM_HIGH)
              urx_in_seq_h.start(p_sequencer.m_uart_rx_agent_seqr.m_uart_rx_agent_seqr);
            //#2us;
            `uvm_info(get_full_name(), "uart_rx_input_seq Sequence complete", UVM_HIGH)
          end
        end  
      join
    endtask : body
  
  endclass : uart_top_simple_test_vseq