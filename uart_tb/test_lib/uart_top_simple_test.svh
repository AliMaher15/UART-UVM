class uart_top_simple_test extends  uart_top_base_test;
    `uvm_component_utils(uart_top_simple_test)
    
   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction : new
  
    task run_phase(uvm_phase phase);
  
      //vseq_class_name vseq_handle = seq_class_name::type_id::create("vseq_handle");
      uart_top_simple_test_vseq m_uart_top_simple_test_vseq = uart_top_simple_test_vseq::type_id::create("m_uart_top_simple_test_vseq");
      set_seqs(m_uart_top_simple_test_vseq);
       
      phase.raise_objection(this);
  
      super.run_phase(phase); 
      
        `uvm_info(get_full_name(),"Starting test", UVM_LOW)
  
        `uvm_info(get_full_name(),"Executing uart_top_simple_test_vseq", UVM_LOW)      
        m_uart_top_simple_test_vseq.start(m_uart_top_env.m_vseqr) ;        
        `uvm_info(get_full_name(), "uart_top_simple_test_vseq complete", UVM_LOW) 
        #1000ns
  
        `uvm_info(get_full_name(),"Ending test", UVM_LOW)
      
      phase.drop_objection(this);
      
    endtask : run_phase
    
  
  endclass : uart_top_simple_test