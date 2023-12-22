# Clocks
add wave /uart_tx_tb_top/dut/CLK
add wave /uart_tx_tb_top/dut/RST

# Inputs
add wave -group UART_TX_IN -color Magenta /uart_tx_tb_top/dut/P_DATA \
                            /uart_tx_tb_top/dut/Data_Valid \
                            /uart_tx_tb_top/dut/PAR_EN \
                            /uart_tx_tb_top/dut/PAR_TYP
                    
# Outputs
add wave -group UART_TX_OUT -color Pink /uart_tx_tb_top/dut/Busy \
                            /uart_tx_tb_top/dut/TX_OUT