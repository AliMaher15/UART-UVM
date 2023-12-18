module parity_calc #( parameter DATA_WIDTH = 8)
(
input   wire                       CLK,
input   wire                       RST,
input   wire    [DATA_WIDTH-1:0]   P_DATA,
input   wire                       PAR_TYP,
input   wire                       par_calc_en,
output  wire                       par_bit
);

// Internal signal
reg     par_bit_r ;

always @(posedge CLK or negedge RST)
    begin
        if (!RST)
            begin
                par_bit_r <= 1'b1 ;
            end
        else if(par_calc_en)                  // Calculate the Parity
            begin
                // 1 is odd parity : 0 is even parity
                par_bit_r <= PAR_TYP ? ~^P_DATA : ^P_DATA ;
            end
    end

assign  par_bit = par_bit_r ;

endmodule