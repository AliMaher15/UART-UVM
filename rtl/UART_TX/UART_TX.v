module UART_TX #( parameter DATA_WIDTH = 8, Counter_WIDTH = 4)
(
input   wire    [DATA_WIDTH-1:0]   P_DATA      ,
input   wire                       Data_Valid  ,
input   wire                       PAR_EN      , 
input   wire                       PAR_TYP     ,
input   wire                       CLK         , 
input   wire                       RST         ,
output  wire                       Busy        ,
output  wire                       TX_OUT
);

// internal connection
wire            ser_en      ;
wire            ser_done    ;
wire            ser_data    ;
wire            par_bit     ;
wire            par_calc_en ;
wire    [1:0]   mux_sel     ;

// FSM
uart_tx_fsm U0_TX_FSM (
.RST(RST),
.CLK(CLK),
.Data_Valid(Data_Valid),
.ser_done(ser_done),        // connected to serializer
.PAR_EN(PAR_EN),
.par_calc_en(par_calc_en),  // connected to parity_calc
.mux_sel(mux_sel),          // connected to MUX
.ser_en(ser_en),            // connected to serializer
.Busy(Busy)
);

// Serializer
Serializer #( .DATA_WIDTH(DATA_WIDTH), .Counter_WIDTH(Counter_WIDTH) ) U0_SERIALIZER (
.RST(RST),
.CLK(CLK),
.P_DATA(P_DATA),
.ser_en(ser_en),            // connected to FSM
.ser_done(ser_done),        // connected to FSM
.ser_data(ser_data)         // connected to MUX
);

// Parity Calculator
parity_calc #( .DATA_WIDTH(DATA_WIDTH) ) U0_PARITY (
.RST(RST),
.CLK(CLK),
.P_DATA(P_DATA),
.par_calc_en(par_calc_en),  // connected to FSM
.PAR_TYP(PAR_TYP),
.par_bit(par_bit)           // connected to MUX
);

// MUX
mux U0_MUX (
.RST(RST),
.CLK(CLK),
.mux_sel(mux_sel),        // connected to FSM
.ser_data(ser_data),      // connected to serializer
.par_bit(par_bit),        // connected to parity calculator
.TX_OUT(TX_OUT)
);

endmodule