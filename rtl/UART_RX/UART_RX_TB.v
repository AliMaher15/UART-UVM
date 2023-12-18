`timescale 1ns/1ps

module UART_RX_TB();

////////////////////////////////////////////////////////
////////////         TB Parameters         /////////////
////////////////////////////////////////////////////////
parameter   clk_period            = 10 ,
            DATA_WIDTH_TB         = 8 ,
            PRESCALE_WIDTH_TB     = 4 , // 8
            BIT_COUNTER_WIDTH_TB  = 4 ;

////////////////////////////////////////////////////////
////////////          TB Signals           /////////////
////////////////////////////////////////////////////////
reg                             CLK_TB      ;
reg                             RST_TB      ;
reg                             RX_IN_TB    ;
reg    [PRESCALE_WIDTH_TB-1:0]  Prescale_TB ;
reg                             PAR_EN_TB   ;
reg                             PAR_TYP_TB  ;
wire   [DATA_WIDTH_TB-1:0]      P_DATA_TB   ;
wire                           data_valid_TB;  

reg     SlowCLK ;                    

////////////////////////////////////////////////////////
/////////////     DUT Instantiation        /////////////
////////////////////////////////////////////////////////
UART_RX #(  .DATA_WIDTH(DATA_WIDTH_TB), 
            .PRESCALE_WIDTH(PRESCALE_WIDTH_TB), 
            .BIT_COUNTER_WIDTH(BIT_COUNTER_WIDTH_TB)
        ) 
DUT     (
.CLK(CLK_TB)          ,
.RST(RST_TB)          ,
.RX_IN(RX_IN_TB)      ,
.Prescale(Prescale_TB),
.PAR_EN(PAR_EN_TB)    ,
.PAR_TYP(PAR_TYP_TB)  ,
.P_DATA(P_DATA_TB)    ,
.data_valid(data_valid_TB)
);

////////////////////////////////////////////////////////
////////////       Clock Generator         /////////////
////////////////////////////////////////////////////////
initial
 begin
  forever #5  CLK_TB = ~CLK_TB ;
 end

initial
 begin
  forever #40  SlowCLK = ~SlowCLK ;
 end

////////////////////////////////////////////////////////
////////////            INITIAL             ////////////
////////////////////////////////////////////////////////
initial
 begin
$dumpfile("UART_RX.vcd");
$dumpvars;
      
// initialization
initialize() ;

// Reset the design
reset();

delay_periods(Prescale_TB) ;

$display("\n*************************");
$display("****** TEST CASE 1 ******");
$display("*************************");
$display("Parity is enabled & Parity Type is even");
input_with_parity(1'b0, 11'b00110100101) ;
$display("input data = 0 8'b01101001 0 1");
$display("expected valid output data = 8'b10010110\n");
delay_periods(Prescale_TB - 'd1);
check_output_valid(8'b10010110, 1'b1);

delay_periods(Prescale_TB) ;

$display("\n*************************");
$display("****** TEST CASE 2 ******");
$display("*************************");
$display("Parity is enabled & Parity Type is even");
input_with_parity(1'b0, 11'b01010101011) ;
$display("input data = 0 8'b10101010 1 1");
$display("The input Parity bit is Wrong so expected invalid output\n");
delay_periods(Prescale_TB - 'd1);
check_output_valid(8'b01010101, 1'b0);

delay_periods(Prescale_TB) ;

$display("\n*************************");
$display("****** TEST CASE 3 ******");
$display("*************************");
$display("Parity is enabled & Parity Type is odd");
input_with_parity(1'b1, 11'b00110100111) ;
$display("input data = 0 8'b01101001 1 1");
$display("expected valid output data = 8'b10010110\n");
delay_periods(Prescale_TB - 'd1);
check_output_valid(8'b10010110, 1'b1);

delay_periods(Prescale_TB) ;

$display("\n*************************");
$display("****** TEST CASE 4 ******");
$display("*************************");
$display("Parity is enabled & Parity Type is odd");
input_with_parity(1'b1, 11'b01011101011) ;
$display("input data = 0 8'b10111010 1 1");
$display("The input Parity bit is Wrong so expected invalid output\n");
delay_periods(Prescale_TB - 'd1);
check_output_valid(8'b01011101, 1'b0);

delay_periods(Prescale_TB) ;

$display("\n*************************");
$display("****** TEST CASE 5 ******");
$display("*************************");
$display("Parity is Disabled");
input_without_parity(10'b0101101011) ;
$display("input data = 0 8'b10110101 1");
$display("expected valid output data = 8'b10101101\n");
delay_periods(Prescale_TB - 'd1);
check_output_valid(8'b10101101, 1'b1);

delay_periods(Prescale_TB) ;

$display("\n*************************");
$display("****** TEST CASE 6 ******");
$display("*************************");
$display("2 Consecutive frames");
input_without_parity(10'b0011010011) ;
$display("First Frame = 0 8'b01101001 1");
$display("expected valid output data = 8'b10010110\n");
delay_periods(Prescale_TB - 'd1);
check_output_valid(8'b10010110, 1'b1);

delay_periods(1);

$display("2nd Frame = 0 8'b11001100 1");
input_without_parity(10'b0110011001) ;
$display("expected valid output data = 8'b00110011\n");
delay_periods(Prescale_TB - 'd1);
check_output_valid(8'b00110011, 1'b1);

delay_periods(Prescale_TB) ;

$display("\n*************************");
$display("****** TEST CASE 7 ******");
$display("*************************");
$display("Stop bit Error");
input_without_parity(10'b0101000110) ;
$display("input data = 0 8'b10100011 0");
$display("expected output to be Invalid \n");
delay_periods(Prescale_TB - 'd1);
check_output_valid(8'b11000101, 1'b0);

$display("\n*************************");
$display("****** TEST CASE 8 ******");
$display("*************************");
$display("Start bit is a Glitch");
RX_IN_TB = 1'b0 ;
delay_periods(2);
RX_IN_TB = 1'b1 ;
$display("input data = 0 Then after 2 clk cycles returned to 1");
$display("expected output not to change and be invalid \n");
delay_periods(Prescale_TB*2);
check_output_valid(8'b11000101, 1'b0);

#100
$stop;
 end

////////////////////////////////////////////////////////
/////////////            TASKS             /////////////
////////////////////////////////////////////////////////

/////////////// Signals Initialization //////////////////
task initialize ;
 begin
  CLK_TB        = 1'b1 ; 
  RX_IN_TB      = 1'b1 ;
  Prescale_TB   = 'b1000 ; // 8
  PAR_EN_TB     = 1'b0 ;
  PAR_TYP_TB    = 1'b0 ;     // 0: even , 1: odd
  
  SlowCLK       = 1'b1 ;
 end
endtask

///////////////////////// RESET /////////////////////////
task reset ;
 begin
  RST_TB = 1'b1  ;  // deactivated
  #(15)
  RST_TB = 1'b0  ;  // activated
  delay_periods(Prescale_TB) ;
  RST_TB = 1'b1  ;  // decativated
 end
endtask

/////////////// Delay periods  /////////////////
task delay_periods ;
 input integer num ;
 
 begin
  #(clk_period*num) ;
 end
endtask

/////// Input Bits stream with Parity Enabled  //////////
task input_with_parity ;
 input                      typ  ;
 input [DATA_WIDTH_TB+2:0]  data ;
 
 integer i ;
 
 begin
  PAR_EN_TB  = 1'b1 ;
  PAR_TYP_TB = typ  ;
  for(i=DATA_WIDTH_TB+2 ; i>0 ; i=i-1)
    begin
        RX_IN_TB = data[i] ;
        delay_periods(Prescale_TB) ;
    end
  RX_IN_TB = data[0] ;
 end
endtask

////// Input Bits stream with Parity Disabled  ////////
task input_without_parity ;
 input [DATA_WIDTH_TB+1:0]  data ;
 integer i ;
 
 begin
  PAR_EN_TB  = 1'b0 ;
  for(i=DATA_WIDTH_TB+1 ; i>0 ; i=i-1)
    begin
        RX_IN_TB = data[i] ;
        delay_periods(Prescale_TB) ;
    end
  RX_IN_TB = data[0] ;
 end
endtask

///////////////// Check output ////////////////
task check_output_valid ;
 input [DATA_WIDTH_TB-1:0] data ;
 input                     valid;
 
 begin
  $display(" P_DATA=%b",P_DATA_TB);
  $display(" Data Valid=%d",data_valid_TB);
  if(P_DATA_TB == data && data_valid_TB == valid)
    begin
     $display("\n    SUCCESS\n");
    end
   else
    begin
     $display("\n    FAILED\n");
    end 
 end
endtask

endmodule