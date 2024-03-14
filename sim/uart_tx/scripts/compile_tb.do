#***************************************************#
# Set the Project Folder Path
#***************************************************#
set PRJ_PATH "D:/Ali/Courses/Verification-Projects/UART-UVM/uart_tx_tb"

vlog  $PRJ_PATH/rst_intf.sv \
$PRJ_PATH/uart_tx_global_params_pkg.sv \
$PRJ_PATH/uart_tx_item/uart_tx_item_pkg.sv \
$PRJ_PATH/uart_tx_agent/uart_tx_agent_pkg.sv \
$PRJ_PATH/uart_tx_agent/uart_tx_if.sv \
$PRJ_PATH/uart_tx_usertypes_pkg.sv \
$PRJ_PATH/uart_tx_tb_pkg.sv \
$PRJ_PATH/seq_lib/uart_tx_seq_pkg.sv \
$PRJ_PATH/test_lib/uart_tx_test_pkg.sv \
$PRJ_PATH/uart_tx_tb_top.sv \
+incdir+$PRJ_PATH/ \
+incdir+$PRJ_PATH/uart_tx_agent/ \
+incdir+$PRJ_PATH/uart_tx_item/ \
+incdir+$PRJ_PATH/seq_lib/ \
+incdir+$PRJ_PATH/test_lib/ \
+incdir+$PRJ_PATH/uart_tx_checkers/ \
+define+uart_clk_period=10 \
+define+uart_data_width=8