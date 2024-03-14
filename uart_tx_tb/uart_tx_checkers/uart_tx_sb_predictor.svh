// Class: uart_tx_sb_predictor
//
// read p_data, par_en, par_type    (user inputs)
// predict tx_out, parity_bit
class uart_tx_sb_predictor extends uvm_component;
    `uvm_component_utils(uart_tx_sb_predictor);

    // Analysis Implementations
    //
    // connected with uart tx monitor to get p_data, par_en, par_type
    `uvm_analysis_imp_decl(_uart_tx_m)
    uvm_analysis_imp_uart_tx_m#(uart_tx_item, uart_tx_sb_predictor)     uart_tx_imp;

    // Analysis Ports
    //
    uvm_analysis_port #(uart_tx_item) predicted_out_ap;


    //  Constructor: new
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new


    // Class Methods
    //
    // Subscriber Implimintation Function
    extern   function    void          write_uart_tx_m (input uart_tx_item t);
    // Function: out_predictor
    extern   function    uart_tx_item  out_predictor   (input uart_tx_item t);
    // Function: build_phase
    extern   function    void          build_phase(uvm_phase phase);

endclass : uart_tx_sb_predictor


// Function: build_phase
function void uart_tx_sb_predictor::build_phase(uvm_phase phase);
    uart_tx_imp      = new("uart_tx_imp",this);
    predicted_out_ap = new("predicted_out_ap",this);
endfunction: build_phase


// Function: write_uart_tx_m
function void uart_tx_sb_predictor::write_uart_tx_m(input uart_tx_item t);
    uart_tx_item     exp_tr;
    //-------------------------
    exp_tr = out_predictor(t);
    predicted_out_ap.write(exp_tr);
endfunction : write_uart_tx_m


// Function: out_predictor
// check the value driven on p_data, par_en, par_type which the dut should read
// and report on tx_out, parity_bit
function uart_tx_item uart_tx_sb_predictor::out_predictor(input uart_tx_item t);
    bit  [DATA_WIDTH-1:0]  predicted_txout;
    bit  predicted_parity;
    int idx = 0;

    uart_tx_item    tr;
    tr = uart_tx_item::type_id::create("tr");
    //-------------------------
    `uvm_info(get_type_name(), t.sprint(), UVM_HIGH)

    // prediction: tx_out should be equal to what was driven on p_data
    for(int i = DATA_WIDTH-1; i>=0; i--) begin
        predicted_txout[idx] = t.p_data[i];
        idx++;
    end
    // prediction: parity_bit, 1 is odd parity : 0 is even parity
    if(t.par_en) begin
        predicted_parity = t.par_typ ? ~^t.p_data : ^t.p_data ;
    end
    // copy all sampled inputs & outputs
    tr.copy(t);
    // overwrite the values with the calculated values
    tr.tx_out     = predicted_txout;
    if(t.par_en) begin
        tr.parity_bit = predicted_parity;
    end
    return(tr);
endfunction: out_predictor