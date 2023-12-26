class uart_rx_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(uart_rx_scoreboard);

    `uvm_analysis_imp_decl(_uart_rx_out)
    uvm_analysis_imp_uart_rx_out #(uart_rx_item, uart_rx_scoreboard) uart_rx_out_imp;
    `uvm_analysis_imp_decl(_uart_rx_in)
    uvm_analysis_imp_uart_rx_in #(uart_rx_item, uart_rx_scoreboard) uart_rx_in_imp;

    protected int outputs_count = 0;
    protected int stop_error_count = 0;
    protected int parity_error_count = 0;
    protected int data_error_count = 0;

    uart_rx_item item_in_queue [$];
    uart_rx_item item_out_queue [$];

    //  Constructor: new
    function new(string name, uvm_component parent);
        super.new(name, parent);
        uart_rx_out_imp = new("uart_rx_out_imp",this);
        uart_rx_in_imp = new("uart_rx_in_imp",this);
    endfunction: new

    extern function void write_uart_rx_out(input uart_rx_item item);
    extern function void write_uart_rx_in(input uart_rx_item item);
    extern task run_phase(uvm_phase phase);
    extern function void comparator(input uart_rx_item item);
    extern function void check_phase(uvm_phase phase);
    extern function void report_phase(uvm_phase phase);
    
endclass: uart_rx_scoreboard


function void uart_rx_scoreboard::write_uart_rx_out(input uart_rx_item item);
    item_out_queue.push_front(item);
endfunction : write_uart_rx_out

function void uart_rx_scoreboard::write_uart_rx_in(input uart_rx_item item);
    item_in_queue.push_front(item);
endfunction : write_uart_rx_in

task uart_rx_scoreboard::run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
        // variables
        uart_rx_item item_input;
        uart_rx_item item_output;
        uart_rx_item item = new();
        // only start processing if there is an item written
        wait(item_in_queue.size() != 0); // using wait to prevent infinite loop
        // extract the item from the queue
        item_input = item_in_queue.pop_back();
        wait(item_out_queue.size() != 0);
        item_output = item_out_queue.pop_back();
        //*******************************//
        // GROUP THEM INTO ONE ITEM     //
        item.s_data_in           = item_input.s_data_in;
        item.par_en_in           = item_input.par_en_in;
        item.par_typ_in          = item_input.par_typ_in;
        item.insert_parity_error = item_input.insert_parity_error;
        item.insert_stop_error   = item_input.insert_stop_error;
        item.data_valid_out      = item_output.data_valid_out;
        item.parity_error_out    = item_output.parity_error_out;
        item.stop_error_out      = item_output.stop_error_out;
        item.p_data_out          = item_output.p_data_out;
        comparator(item);
    end
endtask: run_phase

function void uart_rx_scoreboard::comparator(input uart_rx_item item);
    bit parity_expected = 0;
    outputs_count++;
    `uvm_info(get_full_name(), $sformatf("\nOUTPUT#%d :", outputs_count), UVM_LOW)
    item.print();

    if (item.insert_parity_error) begin
        if (!item.parity_error_out) begin // should be high
            parity_error_count++;
            `uvm_error(get_full_name(), $sformatf("\nParity error at OUTPUT#%d : expected = %d, result = %d", outputs_count, 1, item.parity_error_out))
        end
    end else if(item.insert_stop_error) begin
        if (!item.stop_error_out) begin // should be high
            stop_error_count++;
            `uvm_error(get_full_name(), $sformatf("\nStop error at OUTPUT#%d : expected = %d, result = %d", outputs_count, 1, item.stop_error_out))
        end
    end else begin // now the p_data should be correct
        if (item.s_data_in != item.p_data_out) begin
            data_error_count++;
            `uvm_error(get_full_name(), $sformatf("\nData error at OUTPUT#%d : expected = %b, result = %b", outputs_count, item.s_data_in, item.p_data_out))
        end
    end
endfunction: comparator


function void uart_rx_scoreboard::check_phase(uvm_phase phase);
    super.check_phase(phase); 
endfunction: check_phase


function void uart_rx_scoreboard::report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_full_name(),$sformatf("outputs_count %0d", outputs_count), UVM_LOW)
    `uvm_info(get_full_name(),$sformatf("stop_error_count %0d", stop_error_count), UVM_LOW)
    `uvm_info(get_full_name(),$sformatf("parity_error_count %0d", parity_error_count), UVM_LOW)
    `uvm_info(get_full_name(),$sformatf("data_error_count %0d", data_error_count), UVM_LOW)
endfunction: report_phase

