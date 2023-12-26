class uart_rx_driver#(DATA_WIDTH = 8, PRESCALE_WIDTH = 4) extends uvm_driver#(uart_rx_item);
    
    `uvm_component_param_utils(uart_rx_driver#(DATA_WIDTH, PRESCALE_WIDTH))
    
    // Interface and Config handles
	virtual uart_rx_if #(DATA_WIDTH, PRESCALE_WIDTH) vif;
	uart_rx_agent_cfg #(DATA_WIDTH, PRESCALE_WIDTH) m_cfg;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);
    //  Task: run_phase
    extern task run_phase(uvm_phase phase);

endclass : uart_rx_driver

function void uart_rx_driver::build_phase(uvm_phase phase);
    // check configuration
    if(!uvm_config_db#(uart_rx_agent_cfg #(DATA_WIDTH, PRESCALE_WIDTH))::get(this, "", "uart_rx_agent_cfg_t", m_cfg))
        `uvm_fatal("uart_rx_driver", "Failed to get uart_rx_agent_cfg_t from database")

    vif = m_cfg.vif;
endfunction: build_phase

task uart_rx_driver::run_phase(uvm_phase phase);

    uart_rx_item m_item;

    forever begin
        //bit [DATA_WIDTH-1:0] s_data_arr = '0;
        bit calculated_parity = 0;

        fork
            begin
                // reset handling
                if(vif.res_n !== 1) begin
                    vif.s_data_in     <= 0;
                    vif.par_en_in     <= 0;
                    vif.par_typ_in    <= 0;
                    @(posedge vif.res_n);
                    // s_data is IDLE
                    vif.s_data_in     <= 1;
                end
                @(negedge vif.res_n); // to prevent infinite loop
            end

            begin
                @(posedge vif.tx_clk);
                if(vif.res_n == 1) begin
                    // s_data is IDLE
                    vif.s_data_in     <= 1;
                    seq_item_port.get_next_item(m_item);
                    `uvm_info(get_full_name(), "\nrecieved item from seq", UVM_HIGH)
                    //m_item.print();

                    @(posedge vif.tx_clk);
                    vif.par_en_in  <= m_item.par_en_in;
                    vif.par_typ_in <= m_item.par_typ_in;
                    // Start bit
                    vif.s_data_in <= 0;

                    // start loading the s_data one by one
                    for (int i=0; i<DATA_WIDTH; i++) begin
                        @(posedge vif.tx_clk);
                        vif.s_data_in <= m_item.s_data_in[i];   
                    end

                    // Parity bit
                    if (m_item.par_en_in) begin
                        case (m_item.par_typ_in)
                /*even*/ 0 : calculated_parity = ^m_item.s_data_in;
                /*odd*/  1 : calculated_parity = ~^m_item.s_data_in;
                        endcase
                        @(posedge vif.tx_clk);
                        if (m_item.insert_parity_error) begin
                            vif.s_data_in <= !calculated_parity;
                        end else begin
                            vif.s_data_in <= calculated_parity;
                        end
                    end

                    // Stop bit
                    @(posedge vif.tx_clk);
                    if (m_item.insert_stop_error) begin
                        vif.s_data_in <= 0;
                    end else begin
                        vif.s_data_in <= 1;
                    end

                    seq_item_port.item_done();
                end
            end
        join_any;
        disable fork;        
    end
endtask: run_phase