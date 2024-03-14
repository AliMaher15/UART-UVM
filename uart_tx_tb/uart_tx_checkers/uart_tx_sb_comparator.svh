// Class: uart_tx_sb_comparator
//
// compare:
    // predicted txout vs actual txout
    // predicted parity vs actual parity (if parity enabled)
class uart_tx_sb_comparator extends uvm_component;

    `uvm_component_utils(uart_tx_sb_comparator);


    // Analysis Exports
    //
    // actual outputs
    uvm_analysis_export   #(uart_tx_item)       axp_out;
    // predicted outputs
    uvm_analysis_export   #(uart_tx_item)       axp_predicted_out;
    
    // TLM FIFOs
    //
    // fifo to extract out writes one by one
    uvm_tlm_analysis_fifo #(uart_tx_item)       expfifo;
    uvm_tlm_analysis_fifo #(uart_tx_item)       outfifo;

    // Variables
    //
    typedef enum int {
        start_error, data_error, parity_error, stop_error
    } error_type;
    error_type error_array [int];
    int TEST_CNT, PASS_CNT, ERROR_CNT;

    // Constructor: new
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction


    // Class Methods
    //
    // Function: build_phase
    extern function void build_phase(uvm_phase phase);
    // Function: connect_phase
    extern function void connect_phase(uvm_phase phase);
    // Task: run_phase
    extern task run_phase(uvm_phase phase);
    // Function: report_phase
    extern function void report_phase(uvm_phase phase); 
    // Task: compare_out
    extern task compare_out(input uart_tx_item exp, uart_tx_item out);
    // Functions: PASS
    extern function void PASS(uart_tx_item out, uart_tx_item exp); 
    // Functions: ERROR
    extern function void ERROR(error_type err, uart_tx_item out, uart_tx_item exp); 
    
endclass : uart_tx_sb_comparator

// Function: build_phase
function void uart_tx_sb_comparator::build_phase(uvm_phase phase);
    axp_out           = new("axp_out"          , this);
    axp_predicted_out = new("axp_predicted_out", this); 

    expfifo = new("expfifo", this); 
    outfifo = new("outfifo", this); 
endfunction : build_phase

// Function: connect_phase
function void uart_tx_sb_comparator::connect_phase(uvm_phase phase); 
    super.connect_phase(phase);
    // connect to predictor
    axp_predicted_out.connect(expfifo.analysis_export); 
    // connect to actual output
    axp_out.connect(outfifo.analysis_export); 
endfunction : connect_phase

// Task: run_phase
task uart_tx_sb_comparator::run_phase(uvm_phase phase);
    uart_tx_item     exp, out;
    fork
        compare_out(exp, out);
    join
endtask: run_phase

// Task: compare_out
task uart_tx_sb_comparator::compare_out(input uart_tx_item exp  , uart_tx_item out);
    bit start_pass, data_pass, parity_pass, stop_pass;
    forever begin 
        start_pass = 0; data_pass = 0; parity_pass = 0; stop_pass = 0;
        `uvm_info(get_type_name(), "WAITING for expected output", UVM_DEBUG)
        expfifo.get(exp); 
        `uvm_info(get_type_name(), "WAITING for actual output"  , UVM_DEBUG)
        outfifo.get(out); 
        if(out.rst_op || exp.rst_op) begin
            `uvm_info(get_type_name(), "flushing fifo", UVM_FULL)
            expfifo.flush();
            outfifo.flush();
            continue;
        end
        TEST_CNT++;
        // check start bit
        if(!out.start_bit) begin
            start_pass = 1;
        end else begin
            ERROR(start_error, out, exp);
        end
        // check data
        if (exp.tx_out == out.tx_out) begin
            data_pass = 1;
        end
        else begin 
            ERROR(data_error, out, exp);
        end
        // check parity bit
        if(out.par_en) begin
            if (exp.parity_bit == out.parity_bit) begin
                parity_pass = 1;
            end
            else begin 
                ERROR(parity_error, out, exp);
            end
        end
        // check stop bit
        if (out.stop_bit) begin
            parity_pass = 1;
        end
        else begin 
            ERROR(stop_error, out, exp);
        end
        // if all passed
        if(start_pass && data_pass && parity_pass && stop_pass) begin
            PASS(out, exp);
        end
    end
endtask: compare_out

// Functions: PASS
function void uart_tx_sb_comparator::PASS(uart_tx_item out, uart_tx_item exp); 
    PASS_CNT++;
    `uvm_info ("PASS", $sformatf("\nActual=%s\nExpected=%s \n",
                                out.sprint(), 
                                exp.sprint()), UVM_HIGH)
endfunction: PASS

// Functions: ERROR
function void uart_tx_sb_comparator::ERROR(error_type err, uart_tx_item out, uart_tx_item exp);
    ERROR_CNT++;
    error_array[TEST_CNT] = err;
    `uvm_error("ERROR", $sformatf("\n%s\nActual=%s\nExpected=%s \n", err,
                                out.sprint(),
                                exp.sprint()))
endfunction: ERROR

// Function: report_phase
function void uart_tx_sb_comparator::report_phase(uvm_phase phase); 
    super.report_phase(phase); 
    if (TEST_CNT && !ERROR_CNT) begin
        `uvm_info(get_type_name(),$sformatf("\n\n\n*** TEST PASSED - %0d vectors ran, %0d vectors passed ***\n", 
                                            TEST_CNT, PASS_CNT), UVM_LOW) 
    end else begin
        `uvm_info(get_type_name(), $sformatf("\n\n\n*** TEST FAILED - %0d vectors ran, %0d vectors passed, %0d vectors failed ***\n",
                                             TEST_CNT, PASS_CNT, ERROR_CNT), UVM_LOW)
    end
    for (int i=1; i<=TEST_CNT; i++) begin
        if(error_array.exists(i))
            `uvm_info(get_type_name(), $sformatf("\nerror at test index %0d : %0s", i, error_array[i].name()), UVM_LOW)
    end
endfunction: report_phase