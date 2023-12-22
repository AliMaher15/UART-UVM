class uart_tx_input_test extends  uart_tx_base_test;
    `uvm_component_utils(uart_tx_input_test)
    
   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction : new
  
    task run_phase(uvm_phase phase);
  
      //vseq_class_name vseq_handle = seq_class_name::type_id::create("vseq_handle");
      uart_tx_input_test_vseq m_uart_tx_input_test_vseq = uart_tx_input_test_vseq::type_id::create("m_uart_tx_input_test_vseq");
      set_seqs(m_uart_tx_input_test_vseq);
       
      phase.raise_objection(this);
  
      super.run_phase(phase); 
      
        `uvm_info("uart_tx_input_test","Starting test", UVM_LOW)
  
        `uvm_info("uart_tx_input_test","Executing uart_tx_input_test_vseq", UVM_LOW)      
        m_uart_tx_input_test_vseq.start(m_uart_tx_env.m_vseqr) ;        
        `uvm_info("uart_tx_input_test", "uart_tx_input_test_vseq complete", UVM_LOW) 
        #500ns
  
        `uvm_info("uart_tx_input_test","Ending test", UVM_LOW)
      
      phase.drop_objection(this);
      
    endtask : run_phase
    
  
  endclass : uart_tx_input_test