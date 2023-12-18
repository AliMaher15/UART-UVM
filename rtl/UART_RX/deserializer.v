module deserializer #( parameter DATA_WIDTH = 8, COUNTER_WIDTH = 3 )
(
input   wire                        CLK,
input   wire                        RST,
input   wire                        Enable,
input   wire                        Sbit,
input   wire    [COUNTER_WIDTH-1:0] edg_cnt,  
output  reg     [DATA_WIDTH-1:0]    P_DATA
);

localparam  cnt_max = (2 ** COUNTER_WIDTH) - 1 ;

always @(posedge CLK or negedge RST)
  begin
    if(!RST)
     begin
        P_DATA <= 'b0 ;
     end
    else if(Enable && edg_cnt == cnt_max)
     begin
        P_DATA <= { Sbit, P_DATA[DATA_WIDTH-1:1] } ;
     end
  end

endmodule