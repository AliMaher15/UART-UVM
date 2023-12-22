class uart_tx_monitor#(DATA_WIDTH = 8) extends uvm_monitor;
    
    `uvm_component_param_utils(uart_tx_monitor#(DATA_WIDTH))

    // Interface and Config handles
	virtual uart_tx_if #(DATA_WIDTH) vif;
	uart_tx_agent_cfg #(DATA_WIDTH) m_cfg;

    uvm_analysis_port #(uart_tx_item) input_ap;
    uvm_analysis_port #(uart_tx_item) output_ap;
    

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);
    //  Task: run_phase
    extern task run_phase(uvm_phase phase);

endclass : uart_tx_monitor

function void uart_tx_monitor::build_phase(uvm_phase phase);
    // check configuration
    if(!uvm_config_db#(uart_tx_agent_cfg #(DATA_WIDTH))::get(this, "", "uart_tx_agent_cfg_t", m_cfg))
        `uvm_fatal("uart_tx_monitor", "Failed to get uart_tx_agent_cfg_t from database")

    vif = m_cfg.vif;
    input_ap = new("input_ap", this);
    output_ap = new("output_ap", this);
endfunction: build_phase

task uart_tx_monitor::run_phase(uvm_phase phase);

    uart_tx_item m_item;
    m_item = uart_tx_item::type_id::create("m_item");

    forever begin

      if(vif.res_n !== 1) begin
        `uvm_info("uart_tx_monitor","waiting for reset",UVM_HIGH)
        @(posedge vif.res_n);
      end
      
      @(posedge vif.clk);
      //inputs
      m_item.p_data = vif.p_data;
      m_item.par_en = vif.par_en;
      m_item.par_typ = vif.par_typ;
      m_item.data_valid = vif.data_valid;
      //outputs
      m_item.busy = vif.busy;
      m_item.tx_out = vif.tx_out;

      // for Coverage
      if(vif.data_valid) input_ap.write(m_item);

      output_ap.write(m_item);
        
    end
endtask: run_phase