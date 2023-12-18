module uart_rx_fsm #( parameter DATA_WIDTH = 8,
                                BIT_COUNTER_WIDTH = 4,
                                EDGE_COUNTER_WIDTH = 3
                    )
(
input   wire                                CLK        ,
input   wire                                RST        ,
input   wire                                RX_IN      ,
input   wire                                PAR_EN     ,
input   wire    [BIT_COUNTER_WIDTH-1:0]     bit_cnt    ,
input   wire    [EDGE_COUNTER_WIDTH-1:0]    edg_cnt    ,
input   wire                                par_err    ,
input   wire                                strt_glitch,
input   wire                                stp_err    ,
output  reg                                 dat_samp_en,
output  reg                                 bit_edg_en ,
output  reg                                 par_chk_en ,
output  reg                                 strt_chk_en,
output  reg                                 stp_chk_en ,
output  reg                                 deser_en   ,
output  reg                                 data_valid
);

// Counters parameters    
localparam  edge_counter_max = (2 ** EDGE_COUNTER_WIDTH) - 1 ,
            edge_counter_before_max = edge_counter_max - 2   ;

//states
localparam          IDLE      = 3'b000 ,
                    Start_bit = 3'b001 ,
                    data      = 3'b011 ,
                    par_bit   = 3'b010 ,
                    Stop_bit  = 3'b110 ,
                    Err_Chk   = 3'b111 ,
                    Valid     = 3'b101 ;

reg      [2:0]      current_state ,
                    next_state    ;

//state transition
always @ (posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
    current_state <= IDLE ;
   end
  else
   begin
    current_state <= next_state ;
   end
 end
 
 //next state logic
always @ (*)
 begin
   case (current_state)
   IDLE     : begin
               if(RX_IN)
                 begin
                  next_state = IDLE ;
                 end
               else
                 begin
                  next_state = Start_bit ;
                 end 
              end
   Start_bit: begin
               if(edg_cnt == edge_counter_max)
                begin
                  if(strt_glitch)
                    begin
                      next_state = IDLE ;
                    end
                  else
                    begin
                      next_state = data ;
                    end
                end
               else
                begin
                    next_state = Start_bit ;
                end
             end
   data :     begin
               if(bit_cnt == DATA_WIDTH && edg_cnt == edge_counter_max)
                 begin
                    if(PAR_EN)
                      begin
                        next_state = par_bit ;
                      end
                    else
                      begin
                        next_state = Stop_bit ;
                      end
                 end
               else
                 begin
                    next_state = data ;
                 end
             end
   par_bit  : begin
               if(edg_cnt == edge_counter_max)
                 begin
                    next_state = Stop_bit ;
                 end
               else
                 begin
                    next_state = par_bit ;
                 end
             end
   Stop_bit : begin
               if(edg_cnt == edge_counter_before_max)
                 begin
                    next_state = Err_Chk ;
                 end
               else
                 begin
                    next_state = Stop_bit ;
                 end
             end
   Err_Chk  : begin
               if( (par_err && PAR_EN) || stp_err)
                 begin
                    next_state = IDLE ;
                 end
               else
                 begin
                    next_state = Valid ;
                 end
             end
   Valid    : begin
               if(RX_IN)
                 begin
                    next_state = IDLE ;
                 end
               else
                 begin
                    next_state = Start_bit ;
                 end
             end
   default  : begin
               next_state = IDLE  ;
             end  
   endcase   
 end
 
 //output logic
always @ (*)
 begin
   dat_samp_en = 1'b0 ;
   bit_edg_en  = 1'b0 ;
   par_chk_en  = 1'b0 ;
   strt_chk_en = 1'b0 ;
   stp_chk_en  = 1'b0 ;
   deser_en    = 1'b0 ;
   data_valid  = 1'b0 ;
   case (current_state)
   IDLE     :  begin
                    if(RX_IN)
                      begin
                        dat_samp_en = 1'b0 ;
                        bit_edg_en  = 1'b0 ;
                        strt_chk_en = 1'b0 ;
                      end
                    else
                      begin
                        dat_samp_en = 1'b1 ;
                        bit_edg_en  = 1'b1 ;
                        strt_chk_en = 1'b1 ;
                      end
             end
   Start_bit:  begin
                    dat_samp_en = 1'b1 ;
                    bit_edg_en  = 1'b1 ;
                    strt_chk_en = 1'b1 ;
             end
   data     :  begin
                    dat_samp_en = 1'b1 ;
                    bit_edg_en  = 1'b1 ;
                    deser_en    = 1'b1 ;
             end
   par_bit  :  begin
                    dat_samp_en = 1'b1 ;
                    bit_edg_en  = 1'b1 ;
                    par_chk_en  = 1'b1 ;
             end
   Stop_bit :  begin
                    dat_samp_en = 1'b1 ;
                    bit_edg_en  = 1'b1 ;
                    stp_chk_en  = 1'b1 ;
             end
   Valid    :  begin
                    data_valid  = 1'b1 ;
             end
   default  :  begin
                    dat_samp_en = 1'b0 ;
                    bit_edg_en  = 1'b0 ;
                    par_chk_en  = 1'b0 ;
                    strt_chk_en = 1'b0 ;
                    stp_chk_en  = 1'b0 ;
                    deser_en    = 1'b0 ;
                    data_valid  = 1'b0 ;
             end  
   endcase   
 end
 
endmodule