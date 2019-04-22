vlib work
vlog -timescale 1ns/1ns part2.v
vsim control
log {/*}
add wave {/*}

force {clock} 0 0, 1 1 -r 2
force {reset} 1

force {go} 0
run 10
force {go} 1
run 20