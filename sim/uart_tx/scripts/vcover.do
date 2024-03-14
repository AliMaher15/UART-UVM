
# can use instance=/tb/dut/* to cover all dut's instances

vcover report coverage/uart_tx.ucdb  -cvg      -details                                 -output   coverage/fun_coverage.txt
vcover report coverage/uart_tx.ucdb  -details  -assert                                  -output   coverage/assertions.txt
vcover report coverage/uart_tx.ucdb  -instance=/uart_tx_tb_top/dut/*               -output   coverage/code_coverage.txt
vcover report coverage/uart_tx.ucdb  -instance=/uart_tx_tb_top/dut/*  -details     -output   coverage/code_coverage_details.txt