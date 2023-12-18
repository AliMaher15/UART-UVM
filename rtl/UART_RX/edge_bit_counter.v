module edge_bit_counter #( parameter BIT_COUNTER_WIDTH = 4,
                                     EDGE_COUNTER_WIDTH = 3
                         )
(
input   wire                                CLK     ,
input   wire                                RST     ,
input   wire                                Enable  ,
output  reg     [BIT_COUNTER_WIDTH-1:0]     bit_cnt ,
output  reg     [EDGE_COUNTER_WIDTH-1:0]    edg_cnt   
);

localparam  edg_cnt_max = (2 ** EDGE_COUNTER_WIDTH) - 1 ;

// Internal Signals
wire    edg_cnt_dn ;

// Edge Counter
always @(posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
        edg_cnt <= 'b0 ;
      end
    else if(Enable)
      begin
        if(edg_cnt_dn)
         begin
            edg_cnt <= 'b0 ;
         end
        else
         begin
            edg_cnt <= edg_cnt + 'b1 ;
         end
      end
    else
      begin
        edg_cnt <= 'b0 ;
      end
  end

assign edg_cnt_dn = (edg_cnt == edg_cnt_max) ? 1'b1 : 1'b0 ;

// bit counter 
always @ (posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
    bit_cnt <= 'b0 ;
   end
  else if(Enable)
   begin
    if (edg_cnt_dn)
	 begin
      bit_cnt <= bit_cnt + 'b1 ;
	 end
   end 
  else
   begin
    bit_cnt <= 'b0 ;
   end	
 end 

endmodule