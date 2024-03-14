class uart_tx_driver#(DATA_WIDTH = 8) extends uvm_driver#(uart_tx_item);
    
    `uvm_component_param_utils(uart_tx_driver#(DATA_WIDTH))
    
    // Interface and Config handles
	virtual uart_tx_if#(DATA_WIDTH)  vif;
	uart_tx_agent_cfg #(DATA_WIDTH)  m_cfg;
    // reset event activated by agent
    event           reset_driver;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);
    //  Task: run_phase
    extern task run_phase(uvm_phase phase);
    // Task: run_driver
    extern task run_driver();
    // Function: cleanup
    extern function void cleanup();
    // Task : reset_phase
    extern task reset_phase(uvm_phase phase);

endclass : uart_tx_driver


function void uart_tx_driver::build_phase(uvm_phase phase);
    // check configuration
    if(!uvm_config_db#(uart_tx_agent_cfg #(DATA_WIDTH))::get(this, "", "uart_tx_agent_cfg_t", m_cfg))
        `uvm_fatal(get_full_name(), "Failed to get agent_cfg from database")

    vif = m_cfg.vif;
endfunction: build_phase


// Task : reset_phase
task uart_tx_driver::reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    cleanup();
endtask: reset_phase


//  Task: run_phase
task uart_tx_driver::run_phase(uvm_phase phase);
    forever begin
        @(posedge vif.res_n);

        fork
            run_driver();
        join_none
        @(reset_driver);
        disable fork;
        cleanup();
    end
endtask: run_phase


task uart_tx_driver::run_driver();

    uart_tx_item m_item;

    forever begin

        seq_item_port.get_next_item(m_item);
        @(posedge vif.clk);

        while (vif.busy) begin
            @(posedge vif.clk);
        end

        vif.par_en     <= m_item.par_en;
        vif.par_typ    <= m_item.par_typ;
        vif.p_data     <= m_item.p_data;

        // data valid is high for only 1 clock cycle
        @(posedge vif.clk);
        vif.data_valid <= 1;
        @(posedge vif.clk);
        vif.data_valid <= 0;

        seq_item_port.item_done();

        @(posedge vif.clk);

    end

endtask: run_driver


// Function: cleanup
function void uart_tx_driver::cleanup();
    vif.p_data     <= '0;
    vif.data_valid <= 0;
    vif.par_en     <= 0;
    vif.par_typ    <= 0;
endfunction : cleanup