#***************************************************#
# Set the Project Folder Path
#***************************************************#
set PRJ_PATH "D:/Ali/Courses/Verification-Projects/UART-UVM/rtl/UART_TX"

vlog  $PRJ_PATH/mux.v \
$PRJ_PATH/parity_calc.v \
$PRJ_PATH/Serializer.v \
$PRJ_PATH/uart_tx_fsm.v \
$PRJ_PATH/UART_TX.v \
+incdir+$PRJ_PATH/