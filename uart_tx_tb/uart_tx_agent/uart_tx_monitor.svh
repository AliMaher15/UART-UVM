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
    // Task: input_monitor_run
    extern task input_monitor_run();
    // Task: output_monitor_run
    extern task output_monitor_run();
    // Function: cleanup
    extern function void cleanup();

endclass : uart_tx_monitor


function void uart_tx_monitor::build_phase(uvm_phase phase);
    // check configuration
    if(!uvm_config_db#(uart_tx_agent_cfg #(DATA_WIDTH))::get(this, "", "uart_tx_agent_cfg_t", m_cfg))
        `uvm_fatal(get_full_name(), "Failed to get agent_cfg from database")

    vif = m_cfg.vif;
    input_ap  = new("input_ap", this);
    output_ap = new("output_ap", this);
endfunction: build_phase


// Task: run_phase
task uart_tx_monitor::run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.res_n);

      fork
        input_monitor_run();
        output_monitor_run();
      join_none

      @(negedge vif.res_n);
      disable fork;
      cleanup();
    end   
endtask: run_phase


task uart_tx_monitor::input_monitor_run();
    forever begin
      @(posedge vif.clk);
      if(vif.data_valid & !vif.busy) begin
        uart_tx_item m_item = uart_tx_item::type_id::create("m_item");
        //inputs
        m_item.p_data     = vif.p_data;
        m_item.par_en     = vif.par_en;
        m_item.par_typ    = vif.par_typ;
        input_ap.write(m_item);
      end
    end
endtask: input_monitor_run


task uart_tx_monitor::output_monitor_run();
    forever begin     
      @(posedge vif.clk);
      if(vif.data_valid && !vif.busy) begin
        uart_tx_item m_item = uart_tx_item::type_id::create("m_item");
        m_item.p_data     = vif.p_data;
        m_item.par_en     = vif.par_en;
        m_item.par_typ    = vif.par_typ;
        @(posedge vif.clk);
        @(posedge vif.clk);
        // store start bit
        m_item.start_bit = vif.tx_out;
        // store data stream
        for(int i = DATA_WIDTH-1; i>=0; i--) begin
            @(posedge vif.clk);
            m_item.tx_out[i] = vif.tx_out;
        end
        // store parity bit if exists
        if(m_item.par_en) begin
            @(posedge vif.clk);
            m_item.parity_bit = vif.tx_out;
        end
        // store stop bit
        @(posedge vif.clk);
        m_item.stop_bit = vif.tx_out;

        output_ap.write(m_item);
      end  
    end
endtask: output_monitor_run


// Function: cleanup
function void uart_tx_monitor::cleanup();
    // Clear all
    uart_tx_item    cleanup_item = uart_tx_item::type_id::create("cleanup_item");
    cleanup_item.rst_op = 1;
    input_ap.write(cleanup_item);
    output_ap.write(cleanup_item);
  
  endfunction : cleanup