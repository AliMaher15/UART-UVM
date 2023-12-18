module Serializer #( parameter DATA_WIDTH = 8, Counter_WIDTH = 4 )
(
input   wire                       CLK,
input   wire                       RST,
input   wire    [DATA_WIDTH-1:0]   P_DATA,
input   wire                       ser_en,
output  wire                       ser_done,
output  wire                       ser_data
);

// Internal Signals
reg     [Counter_WIDTH-1:0]      counter   ;
reg     [DATA_WIDTH-1:0]      input_buffer ;

// save input into a buffer then shift to output
always @ (posedge CLK)
  begin
    if(counter == 'b0)
        begin
            input_buffer <= P_DATA ;
        end
    else
        begin
            input_buffer <= input_buffer >> 1 ;
        end
  end

// Counter
always @ (posedge CLK or negedge RST)
  begin
    if(!RST)
        begin
            counter <= 'b0 ;
        end
    else if(ser_en)
        begin
            counter <= counter + 'b1 ;
        end
    else
        begin
            counter <= 'b0 ;
        end
  end

// output data
assign ser_data = input_buffer[0] ;

// serial done
assign ser_done = (counter == DATA_WIDTH) ;

endmodule