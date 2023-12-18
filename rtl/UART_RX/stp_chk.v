module stp_chk
(
input   wire    CLK,
input   wire    RST,
input   wire    Enable,
input   wire    Sbit,
output  reg     Error
);

always @(posedge CLK or negedge RST)
  begin
    if(!RST)
     begin
        Error <= 1'b0 ;
     end
    else if(Enable)
     begin
        Error <= (Sbit) ? 1'b0 : 1'b1 ;
     end
  end

endmodule