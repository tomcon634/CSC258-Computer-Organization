vlib work
vlog -timescale 1ps/1ps counter2.v
vsim counter2
log {/*}
add wave {/*}

force {CLOCK_50} 0 0, 1 1 -r 2
force {SW[3]} 1 0, 0 3, 1 5

force {SW[1]} 0
force {SW[0]} 1
run 500000ns