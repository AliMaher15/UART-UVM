class uart_tx_agent_cfg #(DATA_WIDTH = 8) extends uvm_object;

    `uvm_object_param_utils_begin(uart_tx_agent_cfg #(DATA_WIDTH))
    `uvm_object_utils_end

    //Variables
    virtual uart_tx_if #(DATA_WIDTH) vif;
    uvm_active_passive_enum active = UVM_ACTIVE;

    // Randimized variables and configurations
    

    //Constraints


    //Functions

    //  Constructor: new
    function new(string name = "");
        super.new(name);
    endfunction: new
    
endclass : uart_tx_agent_cfg
