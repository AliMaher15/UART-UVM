proc run_test {testname} {

    # Start a new Transcript File
    transcript file log/$testname.log

    # Start Simulation (choose your options)
    vsim top_opt -c    -assertdebug    -debugDB     -fsmdebug    -coverage    +UVM_TESTNAME=$testname
    set NoQuitOnFinish 1
    onbreak {resume}
    log /* -r
    run -all

    # Save Coverage Results in .ucdb file
    coverage attribute -name TESTNAME -value $testname
    coverage save coverage/$testname.ucdb

    # Close Transcript File by making a new one
    transcript file ()

    # draw the dut pins in waveforms
    do waves.do
}

#***************************************************#
# Clean Work Library
#***************************************************#
if [file exists "work"] {vdel -all}
vlib work

#***************************************************#
# Start a new Transcript File
#***************************************************#
transcript file log/compile.log

#***************************************************#
# Compile RTL and TB files
#***************************************************#
do scripts/compile_dut.do
do scripts/compile_tb.do 

#***************************************************#
# Optimizing Design with vopt
#***************************************************#
vopt uart_tx_tb_top -o top_opt -debugdb  +acc +cover=sbecf

#***************************************************#
# Simulation of Tests
#***************************************************#

run_test uart_tx_input_test
run_test idle_reset_test
run_test active_reset_test
run_test state_transition_reset_test
run_test state_transition_reset_test

#***************************************************#
# Close the Transcript file
#***************************************************#
transcript file ()

#***************************************************#
# save the coverage in text files
#***************************************************#
vcover merge  coverage/uart_tx.ucdb \
              coverage/uart_tx_input_test.ucdb   \
              coverage/idle_reset_test.ucdb   \
              coverage/active_reset_test.ucdb  \
              coverage/state_transition_reset_test.ucdb
              
do scripts/vcover.do


#add schematic -full sim:/uart_tx_tb_top/dut
#quit -sim