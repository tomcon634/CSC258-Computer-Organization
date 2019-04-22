vlib work
vlog -timescale 1ns/1ns sequence_detector.v
vsim sequence_detector
log {/*}
add wave {/*}

force {KEY[0]} 1 0, 0 5 -r 10
force {SW[0]} 0 0, 1 13

force {SW[1]} 0
run 30
force {SW[1]} 1
run 50
force {SW[1]} 0
run 20
force {SW[1]} 1
run 20
force {SW[1]} 0
run 10
force {SW[1]} 1
run 15