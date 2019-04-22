vlib work
vlog -timescale 1ns/1ns counter.v
vsim counter
log {/*}
add wave {/*}

force {KEY[0]} 0 0, 1 5 -r 10
force {SW[0]} 1 0, 0 3, 1 8
force {SW[1]} 0 0, 1 25
run 100ns