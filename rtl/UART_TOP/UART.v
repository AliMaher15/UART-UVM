module UART #(parameter DATA_WIDTH = 8,
                        Counter_WIDTH = 4,
                        PRESCALE_WIDTH = 5  //4 or 8 or 16 or 32
             )
(
 input   wire                          RST      ,
 
 input   wire                          TX_CLK   ,
 input   wire   [DATA_WIDTH-1:0]       TX_IN_P  , 
 input   wire                          TX_IN_V  , 
 output  wire                          TX_OUT_S ,
 output  wire                          TX_OUT_B ,

 input   wire                          RX_CLK   ,
 input   wire   [PRESCALE_WIDTH-1:0]   Prescale ,
 input   wire                          RX_IN_S  ,
 output  wire   [DATA_WIDTH-1:0]       RX_OUT_P , 
 output  wire                          RX_OUT_V ,
 
 input   wire                          PAR_EN   ,
 input   wire                          PAR_TYP
);

UART_TX #( .DATA_WIDTH(DATA_WIDTH), .Counter_WIDTH(Counter_WIDTH) ) U0_UART_TX (
.RST(RST)           ,
.CLK(TX_CLK)        ,
.P_DATA(TX_IN_P)    ,
.Data_Valid(TX_IN_V),
.PAR_EN(PAR_EN)     ,
.PAR_TYP(PAR_TYP)   ,
.Busy(TX_OUT_B)     ,
.TX_OUT(TX_OUT_S)
);

UART_RX #( .DATA_WIDTH(DATA_WIDTH), 
           .BIT_COUNTER_WIDTH(Counter_WIDTH),
           .PRESCALE_WIDTH(PRESCALE_WIDTH)
         )
 U0_UART_RX (
 .RST(RST)            ,
 .CLK(RX_CLK)         ,
 .RX_IN(RX_IN_S)      ,
 .Prescale(Prescale)  ,
 .PAR_EN(PAR_EN)      ,
 .PAR_TYP(PAR_TYP)    ,
 .P_DATA(RX_OUT_P)    ,
 .data_valid(RX_OUT_V)
 );

endmodule