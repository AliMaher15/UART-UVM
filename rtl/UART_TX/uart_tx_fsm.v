module uart_tx_fsm
(
input   wire            CLK         ,
input   wire            RST         ,
input   wire            Data_Valid  ,
input   wire            ser_done    ,
input   wire            PAR_EN      ,
output  reg             ser_en      ,
output  reg             par_calc_en ,
output  reg     [1:0]   mux_sel     ,
output  reg             Busy
);

//states
localparam          IDLE      = 3'b000 ,
                    Start_bit = 3'b001 ,
                    ser_data  = 3'b011 ,
                    par_bit   = 3'b010 ,
                    Stop_bit  = 3'b110 ;

reg      [2:0]      current_state ,
                    next_state    ;
                    
// Internal Signals
reg         Busy_c        ;

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
               if(Data_Valid)
                 begin
                  next_state = Start_bit ;
                 end
               else
                 begin
                  next_state = IDLE ;
                 end 
              end
   Start_bit: begin
               next_state = ser_data ;       
             end
   ser_data : begin
               if(!ser_done)
                 begin
                  next_state = ser_data ;
                 end
               else if(PAR_EN)
                      begin
                       next_state = par_bit ;
                      end
               else
                 begin
                  next_state = Stop_bit ;
                 end
             end
    par_bit : begin
               next_state = Stop_bit ;      
             end
   Stop_bit : begin
               next_state = IDLE  ;
             end
   default  : begin
               next_state = IDLE  ;
             end  
   endcase   
 end

//output logic
always @ (*)
 begin
   par_calc_en = 1'b0 ;
   case (current_state)
   IDLE     :  begin
                mux_sel   = 2'b01  ;
                ser_en    = 1'b0   ;
                Busy_c    = 1'b0   ;
             end
   Start_bit:  begin
                mux_sel     = 2'b00 ;
                ser_en      = 1'b1  ;
                par_calc_en = 1'b1  ;
                Busy_c      = 1'b1  ;
             end
   ser_data :  begin
                mux_sel = 2'b10 ;
                ser_en  = 1'b1  ;
                Busy_c  = 1'b1  ;
             end
   par_bit  :  begin
                mux_sel = 2'b11 ;
                ser_en  = 1'b0  ;
                Busy_c  = 1'b1  ;
             end
   Stop_bit :  begin
                mux_sel = 2'b01 ;
                ser_en  = 1'b0  ;
                Busy_c  = 1'b1  ;
             end
   default :   begin
                mux_sel     = 2'b01 ;
                ser_en      = 1'b0  ;
                par_calc_en = 1'b0  ;
                Busy_c      = 1'b0  ;
             end  
   endcase   
 end
 
 // Output Busy signal
 always @(posedge CLK or negedge RST)
   begin
     if(!RST)
       begin
        Busy <= 1'b0 ;
       end
     else
       begin
        Busy <= Busy_c ;
       end
   end
 
endmodule