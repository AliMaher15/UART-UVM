# Clocks
add wave /uart_rx_tb_top/rx_clk
add wave /uart_rx_tb_top/tx_clk
add wave /uart_rx_tb_top/dut/RST

# Inputs
add wave -group UART_RX_IN -color Magenta /uart_rx_tb_top/dut/RX_IN \
                            /uart_rx_tb_top/dut/Prescale \
                            /uart_rx_tb_top/dut/parity_enable \
                            /uart_rx_tb_top/dut/parity_type
                    
# Outputs
add wave -group UART_RX_OUT -color Pink /uart_rx_tb_top/dut/P_DATA \
                            /uart_rx_tb_top/dut/par_err \
                            /uart_rx_tb_top/dut/stp_err \
                            /uart_rx_tb_top/dut/data_valid