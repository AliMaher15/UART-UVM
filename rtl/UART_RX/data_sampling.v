module data_sampling #( parameter PRESCALE_WIDTH = 5 )
(
input   wire                            CLK,
input   wire                            RST,
input   wire                            RX_IN,
input   wire    [PRESCALE_WIDTH-1:0]    Prescale,
input   wire    [PRESCALE_WIDTH-3:0]    edg_cnt,
input   wire                            Enable,
output  reg                             Sbit
);
 
 // Internal Signals
 reg    [2:0]   Samples ;
 
 wire   [PRESCALE_WIDTH-2:0]    Half_Sampled ,
                                Half_plus1   ,
                                Half_neg1    ;
      
// Positions of the Samples    
assign Half_Sampled = (Prescale>>1) - 'b1 ;
assign Half_neg1    = Half_Sampled  - 'b1 ;
assign Half_plus1   = Half_Sampled  + 'b1 ;
 
 // Sampling Values
 always @(posedge CLK or negedge RST)
   begin
     if(!RST)
       begin
            Samples <= 3'b0 ;
       end
     else if(Enable)
       begin
            if(edg_cnt == Half_neg1)
              begin
                Samples[0] <= RX_IN ;
              end
            else if(edg_cnt == Half_Sampled)
              begin
                Samples[1] <= RX_IN ;
              end
            else if(edg_cnt == Half_plus1)
              begin
                Samples[2] <= RX_IN ;
              end // else keeps its value
       end
     else
       begin
            Samples <= 3'b0 ;
       end
   end

// Sampling Decision
always @(posedge CLK or negedge RST)
  begin
    if(!RST)
     begin
        Sbit <= 1'b0 ;
     end
    else if(Enable)
     begin
        case(Samples)
        3'b000  :   begin
                        Sbit <= 1'b0 ;
                   end
        3'b001  :   begin
                        Sbit <= 1'b0 ;
                   end
        3'b010  :   begin
                        Sbit <= 1'b0 ;
                   end
        3'b011  :   begin
                        Sbit <= 1'b1 ;
                   end
        3'b100  :   begin
                        Sbit <= 1'b0 ;
                   end
        3'b101  :   begin
                        Sbit <= 1'b1 ;
                   end
        3'b110  :   begin
                        Sbit <= 1'b1 ;
                   end  
        3'b111  :   begin
                        Sbit <= 1'b1 ;
                   end               
        endcase
     end
    else
     begin
        Sbit <= 1'b0 ;
     end
  end

endmodule