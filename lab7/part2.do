vlib work
vlog -timescale 1ns/1ns part2_test.v
vsim part2_test
log {/*}
add wave {/*}

force {CLOCK_50} 0 0, 1 1 -r 2
force {KEY[0]} 1

force {KEY[3]} 0
run 10
force {KEY[3]} 1

force {SW[9:7]} 111
force {SW[6:0]} 0110011
run 2
force {SW[6:0]} 1001100
run 8