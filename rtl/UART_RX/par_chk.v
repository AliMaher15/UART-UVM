module par_chk #( parameter DATA_WIDTH = 8 )
(
input   wire                        CLK,
input   wire                        RST,
input   wire                        Sbit,
input   wire                        Enable,
input   wire                        PAR_TYP,
input   wire    [DATA_WIDTH-1:0]    P_DATA,
output  reg                         Error
);

// Internal Signal
reg     par_bit_calc ;

always @(posedge CLK or negedge RST)
  begin
    if(!RST)
     begin
        par_bit_calc <= 1'b1 ;
     end
    else if(Enable)
     begin
        // 1 is odd parity : 0 is even parity
        par_bit_calc <= PAR_TYP ? ~^P_DATA : ^P_DATA ;
     end
  end

always @(posedge CLK or negedge RST)
  begin
    if(!RST)
     begin
        Error <= 1'b0 ;
     end
    else if(Enable)
     begin
        Error <= (Sbit == par_bit_calc) ? 1'b0 : 1'b1 ;
     end
  end
    
endmodule