class uart_rx_monitor#(DATA_WIDTH = 8, PRESCALE_WIDTH = 4) extends uvm_monitor;
    
    `uvm_component_param_utils(uart_rx_monitor#(DATA_WIDTH, PRESCALE_WIDTH))

    // Interface and Config handles
	virtual uart_rx_if #(DATA_WIDTH, PRESCALE_WIDTH) vif;
	uart_rx_agent_cfg #(DATA_WIDTH, PRESCALE_WIDTH) m_cfg;

    uvm_analysis_port #(uart_rx_item) input_ap;
    uvm_analysis_port #(uart_rx_item) output_ap;
    

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);
    //  Task: run_phase
    extern task run_phase(uvm_phase phase);

endclass : uart_rx_monitor

function void uart_rx_monitor::build_phase(uvm_phase phase);
    // check configuration
    if(!uvm_config_db#(uart_rx_agent_cfg #(DATA_WIDTH, PRESCALE_WIDTH))::get(this, "", "uart_rx_agent_cfg_t", m_cfg))
        `uvm_fatal(get_full_name(), "Failed to get uart_rx_agent_cfg_t from database")

    vif = m_cfg.vif;
    input_ap = new("input_ap", this);
    output_ap = new("output_ap", this);
endfunction: build_phase

task uart_rx_monitor::run_phase(uvm_phase phase);

    uart_rx_item m_item;
    m_item = uart_rx_item::type_id::create("m_item");

    forever begin

      if(vif.res_n !== 1) begin
        `uvm_info(get_full_name(),"waiting for reset",UVM_HIGH)
        @(posedge vif.res_n);
      end
      
      @(posedge vif.clk);
      // check start bit for a new input
      if (vif.s_data_in == 0) begin
        pass
      end
      //inputs
      m_item.s_data_in = vif.s_data_in;
      m_item.par_en_in = vif.par_en_in;
      m_item.par_typ_in = vif.par_typ_in;
      //outputs
      m_item.data_valid_out = vif.data_valid_out;
      m_item.parity_error_out = vif.parity_error_out;
      m_item.stop_error_out = vif.stop_error_out;
      m_item.p_data_out = vif.p_data_out;

      // for Coverage
      input_ap.write(m_item);
      // for Scoreboard
      output_ap.write(m_item);
        
    end
endtask: run_phase