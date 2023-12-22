class uart_tx_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(uart_tx_scoreboard);

    `uvm_analysis_imp_decl(_uart_tx_out)
    uvm_analysis_imp_uart_tx_out #(uart_tx_item, uart_tx_scoreboard) uart_tx_out_imp;
    parameter data_width = 8;
    protected int outputs_count = 0;
    protected int start_error_count = 0;
    protected int stop_error_count = 0;
    protected int parity_error_count = 0;
    protected int data_error_count = 0;

    uart_tx_item item_queue [$];
    bit          s_data_queue [$:data_width+3];

    //  Constructor: new
    function new(string name, uvm_component parent);
        super.new(name, parent);
        uart_tx_out_imp = new("uart_tx_out_imp",this);
    endfunction: new

    extern function void write_uart_tx_out(input uart_tx_item item);
    extern task run_phase(uvm_phase phase);
    extern function void comparator(input uart_tx_item item, bit start, bit stop, bit parity = 0, bit [data_width-1:0] data);
    extern function void check_phase(uvm_phase phase);
    extern function void report_phase(uvm_phase phase);
    
endclass: uart_tx_scoreboard


function void uart_tx_scoreboard::write_uart_tx_out(input uart_tx_item item);
    if(item.busy)
        item_queue.push_front(item);
    // else : IDLE state
endfunction : write_uart_tx_out

task uart_tx_scoreboard::run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
        // variables
        uart_tx_item item;
        bit start_bit, stop_bit, parity_bit_sent;
        bit data_q [data_width];
        bit [data_width-1:0] data; // normal array
        // only start processing if there is an item written
        wait(item_queue.size() != 0); // using wait to prevent infinite loop
            // extract the item from the queue
            item = item_queue.pop_back();
            // store the serial output bit from item into queue
            s_data_queue.push_front(item.tx_out);
            // Now the length depends on parity enable
            if (item.par_en) begin // parity : length = 1+DATA_WIDTH+1+1
                if (s_data_queue.size() == data_width+3) begin
                    // extract start bit
                    start_bit = s_data_queue.pop_back();
                    // extract data
                    foreach (data_q[i]) begin
                        data_q[data_width-(i+1)] = s_data_queue.pop_back();
                    end
                    data = {>>{data_q}};
                    // extract parity
                    parity_bit_sent = s_data_queue.pop_back();
                    // extract stop
                    stop_bit = s_data_queue.pop_back();
                    comparator(.item(item), .start(start_bit), .stop(stop_bit), .parity(parity_bit_sent), .data(data));
                end
            end else begin // no parity : length = 1+DATA_WIDTH+1
                if (s_data_queue.size() == data_width+2) begin
                    // extract start bit
                    start_bit = s_data_queue.pop_back();
                    // extract data
                    foreach (data_q[i]) begin
                        data_q[data_width-(i+1)] = s_data_queue.pop_back();
                    end
                    data = {>>{data_q}};
                    // extract stop
                    stop_bit = s_data_queue.pop_back();
                    comparator(.item(item), .start(start_bit), .stop(stop_bit), .data(data));
                end
            end
    end
endtask: run_phase

function void uart_tx_scoreboard::comparator(input uart_tx_item item, bit start, bit stop, bit parity = 0, bit [data_width-1:0] data);
    bit parity_expected = 0;
    outputs_count++;
    `uvm_info("uart_tx_scoreboard", $sformatf("\nOUTPUT#%d :", outputs_count), UVM_HIGH)
    //item.print();

    if(start != 0) begin 
        start_error_count++;
        `uvm_error("uart_tx_scoreboard", $sformatf("\nStart error at OUTPUT#%d", outputs_count))
    end
    if(stop != 1) begin 
        stop_error_count++;
        `uvm_error("uart_tx_scoreboard", $sformatf("\nStop error at OUTPUT#%d", outputs_count))
    end
    if(item.p_data != data) begin 
        data_error_count++;
        `uvm_error("uart_tx_scoreboard", $sformatf("\nData error at OUTPUT#%d : expected = %d, result = %d", outputs_count, data, item.tx_out))
    end
    if (item.par_en) begin // check the parity
        if (item.par_typ == 0) begin // even
            parity_expected = ^item.p_data;
        end else begin
            parity_expected = ~(^item.p_data);
        end
        if(parity_expected != parity) begin 
            parity_error_count++;
            `uvm_error("uart_tx_scoreboard", $sformatf("\nParity error at OUTPUT#%d : expected = %d, result = %d", outputs_count, parity_expected, parity))
        end
    end
endfunction: comparator


function void uart_tx_scoreboard::check_phase(uvm_phase phase);
    super.check_phase(phase); 
endfunction: check_phase


function void uart_tx_scoreboard::report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("uart_tx_scoreboard",$sformatf("outputs_count %0d", outputs_count), UVM_LOW)
    `uvm_info("uart_tx_scoreboard",$sformatf("start_error_count %0d", start_error_count), UVM_LOW)
    `uvm_info("uart_tx_scoreboard",$sformatf("stop_error_count %0d", stop_error_count), UVM_LOW)
    `uvm_info("uart_tx_scoreboard",$sformatf("parity_error_count %0d", parity_error_count), UVM_LOW)
    `uvm_info("uart_tx_scoreboard",$sformatf("data_error_count %0d", data_error_count), UVM_LOW)
endfunction: report_phase

