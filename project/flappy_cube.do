vlib work
vlog -timescale 1ns/1ns flappy_cube.v
vsim flappy_cube
log {/*}
add wave {/*}

force {CLOCK_50} 0 0, 1 1 -r 2
force {KEY[0]} 1 0, 0 4, 1 6
force {KEY[1]} 1 0, 0 10, 1 12
force {SW} 2#1111111111
run 500ns