#***************************************************#
# Clean Work Library
#***************************************************#
if [file exists "work"] {vdel -all}
vlib work

#***************************************************#
# Start a new Transcript File
#***************************************************#
transcript file log/RUN_LOG.log
# better make one for each test

#***************************************************#
# Compile RTL and TB files
#***************************************************#
vlog -f scripts/dut.f
vlog -f scripts/tb.f

#***************************************************#
# Optimizing Design with vopt
#***************************************************#
vopt uart_rx_tb_top -o top_opt -debugdb  +acc +cover=sbecf+UART_RX(rtl).

#***************************************************#
# Simulation of a Test
#***************************************************#

#********************************** 1. Input TEST ***********************************#
transcript file log/uart_rx_input_test.log
vsim top_opt -c -assertdebug -debugDB -fsmdebug -coverage +UVM_TESTNAME=uart_rx_input_test
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all
coverage attribute -name TESTNAME -value uart_rx_input_test
coverage save coverage/uart_rx_input_test.ucdb

#***************************************************#
# Close the Transcript file
#***************************************************#
transcript file ()

#***************************************************#
# draw the dut pins in waveforms
#***************************************************#
do waves.do

#***************************************************#
# save the coverage in text files
#***************************************************#
vcover merge  coverage/uart_rx.ucdb \
              coverage/uart_rx_input_test.ucdb   
              
              
vcover report coverage/uart_rx.ucdb -cvg -details -output coverage/fun_coverage.txt
vcover report coverage/uart_rx.ucdb -details -assert  -output coverage/assertions.txt
vcover report coverage/uart_rx.ucdb  -output coverage/code_coverage.txt


#add schematic -full sim:/uart_rx_tb_top/dut
#quit -sim