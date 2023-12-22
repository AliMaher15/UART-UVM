class uart_tx_agent_seqr extends uvm_sequencer #(uart_tx_item);

    `uvm_component_utils(uart_tx_agent_seqr)
    
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

endclass : uart_tx_agent_seqr