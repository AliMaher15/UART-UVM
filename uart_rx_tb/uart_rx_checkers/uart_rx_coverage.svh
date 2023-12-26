class uart_rx_coverage extends uvm_subscriber#(uart_rx_item);
    `uvm_component_utils(uart_rx_coverage)

    /// inputs to dut
    bit [DATA_WIDTH-1:0] s_data_in;
    bit par_en_in;
    bit par_typ_in;
    //configurations
    bit insert_parity_error;
    bit insert_stop_error;

    covergroup cg_parity_stop_configurations;

        cp_parity_enable: coverpoint par_en_in {
            bins on = {1};
            bins off = {0};
        }

        cp_parity_type: coverpoint par_typ_in {
            bins even = {0};
            bins odd = {1};
        }

        cp_parity_error: coverpoint insert_parity_error {
            bins on = {1};
            bins off = {0};
        }

        cp_stop_error: coverpoint insert_stop_error {
            bins on = {1};
            bins off = {0};
        }
        
        cx_par_typ_err_en: cross cp_parity_enable, cp_parity_type, cp_parity_error {
            bins on_even_correct= binsof(cp_parity_enable.on)  && binsof(cp_parity_type.even) && binsof(cp_parity_error.off);
            bins on_even_err    = binsof(cp_parity_enable.on)  && binsof(cp_parity_type.even) && binsof(cp_parity_error.on);
            bins on_odd_correct = binsof(cp_parity_enable.on)  && binsof(cp_parity_type.odd)  && binsof(cp_parity_error.off);
            bins on_odd_err     = binsof(cp_parity_enable.on)  && binsof(cp_parity_type.odd)  && binsof(cp_parity_error.on);
            ignore_bins no_parity = binsof(cp_parity_enable.off);
        }
        
    endgroup: cg_parity_stop_configurations

    covergroup cg_zeros_or_ones_data;

        cp_parallel_data: coverpoint s_data_in {
            bins zeros = {'h00};
            bins ones = {'hFF};
        }
        
    endgroup: cg_zeros_or_ones_data
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        cg_parity_stop_configurations = new();
        cg_zeros_or_ones_data = new();
    endfunction

    function void write(uart_rx_item t);
        s_data_in = t.s_data_in;
        par_en_in = t.par_en_in;
        par_typ_in = t.par_typ_in;
        insert_parity_error = t.insert_parity_error;
        insert_stop_error = t.insert_stop_error;

        // sample covergroups
        cg_parity_stop_configurations.sample();
        cg_zeros_or_ones_data.sample();
    endfunction

endclass : uart_rx_coverage