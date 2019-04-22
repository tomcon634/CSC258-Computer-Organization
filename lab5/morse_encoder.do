vlib work
vlog -timescale 1ns/1ns morse_encoder.v
vsim morse_encoder
log {/*}
add wave {/*}

force {CLOCK_50} 0 0, 1 2 -r 4
force {KEY[0]} 1 0, 0 4, 1 6
force {KEY[1]} 1 0, 0 8, 1 12
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
run 100ns