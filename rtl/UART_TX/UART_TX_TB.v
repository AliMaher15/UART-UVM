`timescale 1ns/1ps

module UART_TX_TB();

////////////////////////////////////////////////////////
////////////         TB Parameters         /////////////
////////////////////////////////////////////////////////
parameter    clk_period = 5 ;
parameter    DATA_WIDTH_TB = 9 ;
integer      j ;

////////////////////////////////////////////////////////
////////////          TB Signals           /////////////
////////////////////////////////////////////////////////
reg                            CLK_TB         ;
reg                            RST_TB         ;
reg    [DATA_WIDTH_TB-1:0]     P_DATA_TB      ;
reg                            Data_Valid_TB  ;
reg                            PAR_EN_TB      ;
reg                            PAR_TYP_TB     ;
wire                           Busy_TB        ;
wire                           TX_OUT_TB      ;

////////////////////////////////////////////////////////
/////////////     DUT Instantiation        /////////////
////////////////////////////////////////////////////////
UART_TX #( .DATA_WIDTH(DATA_WIDTH_TB) ) DUT (
.CLK(CLK_TB),
.RST(RST_TB),
.P_DATA(P_DATA_TB),
.Data_Valid(Data_Valid_TB),
.PAR_EN(PAR_EN_TB),
.PAR_TYP(PAR_TYP_TB),
.Busy(Busy_TB),
.TX_OUT(TX_OUT_TB)
);

////////////////////////////////////////////////////////
////////////       Clock Generator         /////////////
////////////////////////////////////////////////////////
initial
 begin
  forever #2.5  CLK_TB = ~CLK_TB ;
 end

////////////////////////////////////////////////////////
////////////            INITIAL             ////////////
////////////////////////////////////////////////////////
initial
 begin
$dumpfile("UART_TX.vcd");
$dumpvars;
      
// initialization
initialize() ;

// Reset the design
reset();

delay_periods(2) ;              // input is number of periods

$display("\n*************************");
$display("****** TEST CASE 1 ******");
$display("*************************");
$display("Parity is enabled & Parity Type is even");
input_with_parity(1'b0, 4'b1001) ;  // PAR_TYP and P_DATA
$display("input data is 4'b1001");
$display("expected output frame is 0100101\n");
delay_periods(1) ;
check_output(7'b0100101);

delay_periods(2) ;

$display("*************************");
$display("****** TEST CASE 2 ******");
$display("*************************");
$display("Parity is enabled & Parity Type is even");
input_with_parity(1'b0, 4'b0010) ;  // PAR_TYP and P_DATA
$display("input data is 4'b0010");
$display("expected output frame is 0010011\n");
delay_periods(1) ;
check_output(7'b0010011);

delay_periods(2) ;

$display("*************************");
$display("****** TEST CASE 3 ******");
$display("*************************");
$display("Parity is enabled & Parity Type is odd");
input_with_parity(1'b1, 4'b0110) ;  // PAR_TYP and P_DATA
$display("input data is 4'b0110");
$display("expected output frame is 0011011\n");
delay_periods(1) ;
check_output(7'b0011011);

delay_periods(2) ;

$display("*************************");
$display("****** TEST CASE 4 ******");
$display("*************************");
$display("Parity is enabled & Parity Type is odd");
input_with_parity(1'b1, 4'b0010) ;  // PAR_TYP and P_DATA
$display("input data is 4'b0010");
$display("expected output frame is 0010001\n");
delay_periods(1) ;
check_output(7'b0010001);

delay_periods(2) ;

$display("*************************");
$display("****** TEST CASE 5 ******");
$display("*************************");
$display("Parity is not enabled");
input_without_parity(4'b0110) ;  // P_DATA
$display("input data is 4'b0110");
$display("expected output frame is 001101\n");
delay_periods(1) ;
check_output(7'b0011011);



$display("*************************");
$display("****** TEST CASE 6 ******");
$display("*************************");
$display("Try to put a valid data right after 1 idle cycle");
delay_periods(1) ;
input_with_parity(1'b1, 4'b1010) ;  // PAR_TYP and P_DATA
$display("input data is 4'b1010");
$display("expected output frame is 0010111\n");
delay_periods(1) ;
check_output(7'b0010111);

delay_periods(2) ;

$display("*************************");
$display("****** TEST CASE 7 ******");
$display("*************************");
$display("put valid data while busy");
input_with_parity(1'b1, 4'b1001) ;  // PAR_TYP and P_DATA
delay_periods(1) ;
$display("input data is 4'b1001");
$display("expected output frame is 0100111\n");
$display("\n TX_OUT=%b",TX_OUT_TB);
delay_periods(1) ;
$display(" TX_OUT=%b",TX_OUT_TB);
delay_periods(1) ;
$display(" TX_OUT=%b",TX_OUT_TB);

$display("\n Now Change the input data to 4'b1100");
$display(" new output should be 0001111\n");

P_DATA_TB  = 4'b1100 ;
Data_Valid_TB = 1'b1 ;
delay_periods(1) ;
Data_Valid_TB = 1'b0 ;

for(j=3 ; j<7 ; j=j+1)
 begin
  $display(" TX_OUT=%b",TX_OUT_TB);
  delay_periods(1) ;
 end
$display("\n");

#50
$stop;
 end

////////////////////////////////////////////////////////
/////////////            TASKS             /////////////
////////////////////////////////////////////////////////

/////////////// Signals Initialization //////////////////
task initialize ;
 begin
  CLK_TB        = 1'b1  ; 
  P_DATA_TB     = 'b1001 ;
  Data_Valid_TB = 1'b0 ;
  PAR_EN_TB     = 1'b0 ;
  PAR_TYP_TB    = 1'b0 ;
 end
endtask

///////////////////////// RESET /////////////////////////
task reset ;
 begin
  RST_TB = 1'b1  ;  // deactivated
  #(clk_period/2)
  RST_TB = 1'b0  ;  // activated
  #(clk_period/2)
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

/////// Check Valid bit with parity  //////////
task input_with_parity ;
 input        typ  ;
 input [DATA_WIDTH_TB-1:0]  data ;
 
 begin
  PAR_EN_TB  = 1'b1 ;
  PAR_TYP_TB = typ  ;
  P_DATA_TB  = data ;
  Data_Valid_TB = 1'b1 ;
  delay_periods(1) ;
  Data_Valid_TB = 1'b0 ;
 end
endtask

////// Check Valid bit without parity  ////////
task input_without_parity ;
 input [DATA_WIDTH_TB-1:0]  data ;
 
 begin
  PAR_EN_TB  = 1'b0 ;
  P_DATA_TB  = data ;
  Data_Valid_TB = 1'b1 ;
  delay_periods(1) ;
  Data_Valid_TB = 1'b0 ;
 end
endtask

///////////////// Check output ////////////////
task check_output ;
 input [6:0] data ;
 
 integer i;
 reg    [6:0]     tx_out;
 
 begin
  for(i=6 ; i>-1 ; i=i-1)
   begin
    tx_out[i] = TX_OUT_TB;
    delay_periods(1) ;     
   end
  $display(" TX_OUT=%b",tx_out);
  if(tx_out == data)
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