class uart_tx_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(uart_tx_scoreboard)

    // Analysis Exports
    //
    // connected with uart tx agent monitor
    uvm_analysis_export #(uart_tx_item)     axp_in;
    uvm_analysis_export #(uart_tx_item)     axp_out;

    // Predictor and Comparator
    //
    uart_tx_sb_predictor         prd;
    uart_tx_sb_comparator        cmp;

    // Constructor: new
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // Class Methods
    //
    // Function: build_phase
    extern function void build_phase(uvm_phase phase);
    // Function: connect_phase
    extern function void connect_phase(uvm_phase phase); 

endclass : uart_tx_scoreboard


// Function: build_phase
function void uart_tx_scoreboard::build_phase(uvm_phase phase);
    axp_in    = new("axp_in",    this);
    axp_out   = new("axp_out",   this); 
    prd       =  uart_tx_sb_predictor ::type_id::create("prd", this);
    cmp       =  uart_tx_sb_comparator::type_id::create("cmp", this); 
endfunction : build_phase


// Function: connect_phase
function void uart_tx_scoreboard::connect_phase( uvm_phase phase ); 
    // Connect predictor & comparator to respective analysis exports
    axp_in .connect(prd.uart_tx_imp); 
    axp_out.connect(cmp.axp_out); 
    // Connect predictor to comparator
    prd.predicted_out_ap.connect(cmp.axp_predicted_out); 
endfunction: connect_phase