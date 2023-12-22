class uart_rx_driver#(DATA_WIDTH = 8, PRESCALE_WIDTH = 4) extends uvm_driver#(uart_tx_item);
    
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
    extern task delay_periods(input integer num);

endclass : uart_rx_driver

function void uart_rx_driver::build_phase(uvm_phase phase);
    // check configuration
    if(!uvm_config_db#(uart_rx_agent_cfg #(DATA_WIDTH, PRESCALE_WIDTH))::get(this, "", "uart_rx_agent_cfg_t", m_cfg))
        `uvm_fatal("uart_rx_driver", "Failed to get uart_rx_agent_cfg_t from database")

    vif = m_cfg.vif;
endfunction: build_phase

task uart_rx_driver::run_phase(uvm_phase phase);

    uart_rx_item m_item;
    bit [DATA_WIDTH-:0] s_data_arr;
    bit calculated_parity;

    forever begin
        if(vif.res_n !== 1) begin
            vif.s_data_in     <= 0;
            vif.par_en_in     <= 0;
            vif.par_typ_in    <= 0;
            @(posedge vif.res_n);
        end
        // s_data is IDLE
        vif.s_data_in     <= 1;

        randcase
            1 : delay_periods(1);
            2 : repeat(2) delay_periods(1);
            3 : repeat(3) delay_periods(1);
        endcase

        seq_item_port.get_next_item(m_item);
        delay_periods(1);

        vif.par_en_in  <= m_item.par_en_in;
        vif.par_typ_in <= m_item.par_typ_in;
        s_data_arr     <= m_item.s_data_in;

        // Start bit
        vif.s_data_in <= 0;

        // start loading the s_data one by one
        for (int i=0; i<DATA_WIDTH; i++) begin
            delay_periods(1);
            vif.s_data_in <= s_data_arr[i];   
        end

        // Parity bit
        if (m_item.par_en_in) begin
            case (m_item.par_typ_in)
       /*even*/ 0 : calculated_parity = ^s_data_arr;
       /*odd*/  1 : calculated_parity = ~^s_data_arr;
            endcase
            delay_periods(1);
            if (m_item.insert_parity_error) begin
                vif.s_data_in <= !calculated_parity;
            end else begin
                vif.s_data_in <= calculated_parity;
            end
        end

        // Stop bit
        delay_periods(1);
        if (m_item.insert_stop_error) begin
            vif.s_data_in <= 0;
        end else begin
            vif.s_data_in <= 1;
        end

        seq_item_port.item_done();

    end

endtask: run_phase

// due to oversampling, we need to work on the slower clock
task uart_rx_driver::delay_periods(input integer num);
    repeat(vif.prescale_in * num) begin
        @(posedge vif.clk);
    end
endtask: delay_periods
