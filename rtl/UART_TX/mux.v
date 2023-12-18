module mux
(
input   wire            CLK,
input   wire            RST,
input   wire    [1:0]   mux_sel,
input   wire            ser_data,
input   wire            par_bit,
output  reg             TX_OUT
);

// Internal parameters
localparam      Start_bit = 1'b0 ,
                Stop_bit  = 1'b1 ;

// multiplexer operation
always @(posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
        TX_OUT <= 1'b0 ;
      end
    else
       begin
            case(mux_sel)
                2'b00   :   TX_OUT <= Start_bit ;
        
                2'b01   :   TX_OUT <= Stop_bit  ;
        
                2'b10   :   TX_OUT <= ser_data  ;
        
                2'b11   :   TX_OUT <= par_bit   ;
            endcase
      end
  end

endmodule