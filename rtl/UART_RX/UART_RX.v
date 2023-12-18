module UART_RX 
#( parameter DATA_WIDTH = 8, 
             PRESCALE_WIDTH = 5,   // 32 or 16 or 8 or 4
             BIT_COUNTER_WIDTH = 4
 )
(
input   wire                            CLK     ,
input   wire                            RST     ,
input   wire                            RX_IN   ,
input   wire    [PRESCALE_WIDTH-1:0]    Prescale,
input   wire                            PAR_EN  ,
input   wire                            PAR_TYP ,
output  wire    [DATA_WIDTH-1:0]        P_DATA  ,
output  wire                            data_valid
);

// Internal Signals
wire    [BIT_COUNTER_WIDTH-1:0] bit_cnt ;
wire    [PRESCALE_WIDTH-3:0]    edg_cnt ;

wire    bit_edg_en ,
        par_err    ,
        strt_glitch,
        stp_err    ,
        par_chk_en ,
        strt_chk_en,
        stp_chk_en ,
        deser_en   ,
        dat_samp_en;

wire    sampled_bit;

// FSM
uart_rx_fsm #( .DATA_WIDTH(DATA_WIDTH), 
               .BIT_COUNTER_WIDTH(BIT_COUNTER_WIDTH), 
               .EDGE_COUNTER_WIDTH(PRESCALE_WIDTH-2) 
             ) 
U0_uart_rx_fsm (
.CLK(CLK)                ,
.RST(RST)                ,
.RX_IN(RX_IN)            ,
.PAR_EN(PAR_EN)          ,
.bit_cnt(bit_cnt)        ,
.edg_cnt(edg_cnt)        ,
.par_err(par_err)        ,
.strt_glitch(strt_glitch),
.stp_err(stp_err)        ,
.bit_edg_en(bit_edg_en)  ,
.dat_samp_en(dat_samp_en),
.par_chk_en(par_chk_en)  ,
.strt_chk_en(strt_chk_en),
.stp_chk_en(stp_chk_en)  ,
.deser_en(deser_en)      ,
.data_valid(data_valid)
);

// Edge and Bit Counter
edge_bit_counter #( .BIT_COUNTER_WIDTH(BIT_COUNTER_WIDTH), 
                    .EDGE_COUNTER_WIDTH(PRESCALE_WIDTH-2) 
                  ) 
U0_edge_bit_counter (
.CLK(CLK)           ,
.RST(RST)           ,
.Enable(bit_edg_en) ,
.bit_cnt(bit_cnt)   ,
.edg_cnt(edg_cnt)   
);

// Data Sampling
data_sampling #(.PRESCALE_WIDTH(PRESCALE_WIDTH) ) U0_Data_Sampling (
.CLK(CLK)            ,
.RST(RST)            ,
.Prescale(Prescale)  ,
.RX_IN(RX_IN)        ,     
.Enable(dat_samp_en) ,
.edg_cnt(edg_cnt)    ,
.Sbit(sampled_bit)   
);

// DeSerializer
deserializer #(.DATA_WIDTH(DATA_WIDTH), 
               .COUNTER_WIDTH(PRESCALE_WIDTH-2) 
              ) 
U0_Deserializer (
.CLK(CLK)          ,
.RST(RST)          ,
.Sbit(sampled_bit) ,
.Enable(deser_en)  ,
.edg_cnt(edg_cnt)  ,
.P_DATA(P_DATA)
);

strt_chk U0_Strt_Check (
.CLK(CLK)            ,
.RST(RST)            ,
.Enable(strt_chk_en) ,
.Sbit(sampled_bit)   ,
.glitch(strt_glitch)
);

par_chk #(.DATA_WIDTH(DATA_WIDTH) ) U0_Parity_Check (
.CLK(CLK)           ,
.RST(RST)           ,
.Sbit(sampled_bit)  ,
.Enable(par_chk_en) ,
.PAR_TYP(PAR_TYP)   ,
.P_DATA(P_DATA)     ,
.Error(par_err)
);

stp_chk U0_Stop_Check (
.CLK(CLK)           ,
.RST(RST)           ,
.Enable(stp_chk_en) ,
.Sbit(sampled_bit)  ,
.Error(stp_err)
);

endmodule