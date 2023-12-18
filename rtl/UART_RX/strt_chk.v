module strt_chk
(
input   wire    CLK,
input   wire    RST,
input   wire    Enable,
input   wire    Sbit,
output  reg     glitch
);

always @(posedge CLK or negedge RST)
  begin
    if(!RST)
     begin
        glitch <= 1'b0 ;
     end
    else if(Enable)
     begin
        glitch <= Sbit ;
     end
  end

endmodule