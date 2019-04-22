vlib work
vlog -timescale 1ns/1ns shift_register.v
vsim shift_register
log {/*}
add wave {/*}

force {KEY[0]} 0 0, 1 5 -r 10
force {KEY[1]} 0 0, 1 13
force {KEY[2]} 1
force {KEY[3]} 0 0, 1 50
force {SW[9]} 0 0, 1 3
force {SW[7]} 0
force {SW[6]} 1
force {SW[5]} 1
force {SW[4]} 0
force {SW[3]} 1
force {SW[2]} 0
force {SW[1]} 0
force {SW[0]} 1
run 100ns