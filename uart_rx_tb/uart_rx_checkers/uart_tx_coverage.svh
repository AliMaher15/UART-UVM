class uart_tx_coverage extends uvm_subscriber#(uart_tx_item);
    `uvm_component_utils(uart_tx_coverage)

    parameter data_width = 8;
    /// inputs to dut
    bit [data_width-1:0] p_data;
    bit par_en;
    bit par_typ;

    covergroup cg_parity_configurations;

        cp_parity_enable: coverpoint par_en {
            bins on = {1};
            bins off = {0};
        }

        cp_parity_type: coverpoint par_typ {
            bins even = {0};
            bins odd = {1};
        }
        
        cx_par_typ_en: cross cp_parity_enable, cp_parity_type {
            bins on_even  = binsof(cp_parity_enable.on)  && binsof(cp_parity_type.even);
            bins on_odd   = binsof(cp_parity_enable.on)  && binsof(cp_parity_type.odd);
            bins off_even = binsof(cp_parity_enable.off) && binsof(cp_parity_type.even);
            bins off_odd  = binsof(cp_parity_enable.off) && binsof(cp_parity_type.odd);
        }
        
    endgroup: cg_parity_configurations

    covergroup cg_zeros_or_ones_data;

        cp_parallel_data: coverpoint p_data {
            bins zeros = {'h00};
            bins ones = {'hFF};
        }
        
    endgroup: cg_zeros_or_ones_data
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        cg_parity_configurations = new();
        cg_zeros_or_ones_data = new();
    endfunction

    function void write(uart_tx_item t);
        p_data = t.p_data;
        par_en = t.par_en;
        par_typ = t.par_typ;
        // sample covergroups
        cg_parity_configurations.sample();
        cg_zeros_or_ones_data.sample();
    endfunction

endclass : uart_tx_coverage