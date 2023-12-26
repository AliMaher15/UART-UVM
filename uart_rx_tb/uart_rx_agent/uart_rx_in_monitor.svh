class uart_rx_in_monitor#(DATA_WIDTH = 8, PRESCALE_WIDTH = 4) extends uvm_monitor;
    
    `uvm_component_param_utils(uart_rx_in_monitor#(DATA_WIDTH, PRESCALE_WIDTH))

    // Interface and Config handles
	  virtual uart_rx_if #(DATA_WIDTH, PRESCALE_WIDTH) vif;
	  uart_rx_agent_cfg #(DATA_WIDTH, PRESCALE_WIDTH) m_cfg;

    //int in_counter = 0;
    uvm_analysis_port #(uart_rx_item) input_ap;
    

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);
    //  Task: run_phase
    extern task run_phase(uvm_phase phase);
    extern task monitor_input();

endclass : uart_rx_in_monitor

function void uart_rx_in_monitor::build_phase(uvm_phase phase);
    // check configuration
    if(!uvm_config_db#(uart_rx_agent_cfg #(DATA_WIDTH, PRESCALE_WIDTH))::get(this, "", "uart_rx_agent_cfg_t", m_cfg))
        `uvm_fatal(get_full_name(), "Failed to get uart_rx_agent_cfg_t from database")

    vif = m_cfg.vif;
    input_ap = new("input_ap", this);
endfunction: build_phase

task uart_rx_in_monitor::run_phase(uvm_phase phase);
    forever begin
      if(vif.res_n !== 1) begin
        `uvm_info(get_full_name(),"waiting for reset",UVM_HIGH)
        @(posedge vif.res_n);
      end
        monitor_input();  
    end   
endtask: run_phase


task uart_rx_in_monitor::monitor_input();
    bit [DATA_WIDTH-1:0] s_data_arr;
    bit extracted_parity;
    uart_rx_item m_in_item;
    m_in_item = uart_rx_item::type_id::create("m_in_item");
  
    @(posedge vif.tx_clk);
    // check start bit for a new input
    if (vif.s_data_in == 0) begin
      m_in_item.par_en_in = vif.par_en_in;
      m_in_item.par_typ_in = vif.par_typ_in;

      // now extract all the sent data
      for (int i=0; i<DATA_WIDTH; ++i) begin
          @(posedge vif.tx_clk);
          s_data_arr[i] = vif.s_data_in;
      end
      m_in_item.s_data_in = s_data_arr;
      // next is either parity bit or just stop bit
      @(posedge vif.tx_clk);
      // check parity
      if (vif.par_en_in) begin
        // extract the parity
        case (vif.par_typ_in)
          /*even*/ 0 : extracted_parity = ^s_data_arr;
          /*odd*/  1 : extracted_parity = ~^s_data_arr;
        endcase
        // check if an error occured and if it is intentional
        if (extracted_parity == vif.s_data_in) begin
          m_in_item.insert_parity_error = 0;
        end else begin
          m_in_item.insert_parity_error = 1;
        end
      end
      // stop bit
      @(posedge vif.tx_clk);
      if (vif.s_data_in == 1) begin
        m_in_item.insert_stop_error = 0;
      end else begin
        m_in_item.insert_stop_error = 1;
      end 
      // for Coverage 
      input_ap.write(m_in_item);
      /*in_counter++;
      `uvm_info(get_full_name(), $sformatf("\n input: %d\ns_data=%b\npar_en=%b\npar_typ=%b\nins_par_err=%b\nins_stp_err=%b",
                                            in_counter,
                                            m_in_item.s_data_in,
                                            m_in_item.par_en_in,
                                            m_in_item.par_typ_in,
                                            m_in_item.insert_parity_error,m_in_item.insert_stop_error), UVM_LOW)
      */
      //m_in_item.print();
    end
endtask: monitor_input


/*
task uart_rx_monitor::run_phase(uvm_phase phase);

  forever begin

    if(vif.res_n !== 1) begin
      `uvm_info(get_full_name(),"waiting for reset",UVM_HIGH)
      @(posedge vif.res_n);
    end

    @(posedge vif.tx_clk);
    // check start bit for a new input
    if (vif.s_data_in == 0) begin
      m_item.par_en_in = vif.par_en_in;
      m_item.par_typ_in = vif.par_typ_in;

      // now extract all the sent data
      for (int i=0; i<DATA_WIDTH; ++i) begin
          @(posedge vif.tx_clk);
          s_data_arr[i] = vif.s_data_in;
      end
      m_item.s_data_in = s_data_arr;
      // next is either parity bit or just stop bit
      @(posedge vif.tx_clk);
      // check parity
      if (vif.par_en_in) begin
        // extract the parity
        case (vif.par_typ_in)
           0 : extracted_parity = ^s_data_arr; //even
           1 : extracted_parity = ~^s_data_arr; //odd 
        endcase
        // check if an error occured and if it is intentional
        if (extracted_parity == vif.s_data_in) begin
          m_item.insert_parity_error = 0;
        end else begin
          m_item.insert_parity_error = 1;
        end
        //@(posedge vif.tx_clk); 
      end
      // stop bit
      @(posedge vif.data_valid_out);
      if (vif.s_data_in == 1) begin
        m_item.insert_stop_error = 0;
      end else begin
        m_item.insert_stop_error = 1;
      end
        m_item.data_valid_out = vif.data_valid_out;
        m_item.parity_error_out = vif.parity_error_out;
        m_item.stop_error_out = vif.stop_error_out;
        m_item.p_data_out = vif.p_data_out;
      // for Coverage 
      input_ap.write(m_item);
      // for Scoreboard
      output_ap.write(m_item);
    end   
  end
endtask: run_phase
*/