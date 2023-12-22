class uart_rx_agent_cfg #(DATA_WIDTH = 8, PRESCALE_WIDTH = 4) extends uvm_object;

    `uvm_object_param_utils_begin(uart_rx_agent_cfg #(DATA_WIDTH, PRESCALE_WIDTH))
    `uvm_object_utils_end

    //Variables
    virtual uart_rx_if #(DATA_WIDTH, PRESCALE_WIDTH) vif;
    uvm_active_passive_enum active = UVM_ACTIVE;

    // Randimized variables and configurations
    

    //Constraints


    //Functions

    //  Constructor: new
    function new(string name = "");
        super.new(name);
    endfunction: new
    
endclass : uart_rx_agent_cfg
