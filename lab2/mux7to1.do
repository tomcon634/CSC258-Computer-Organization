vlib work
vlog -timescale 1ns/1ns mux7to1.v
vsim mux7to1
log {/*}
add wave {/*}

force {SW[0]} 0 0, 1 50 -r 100
force {SW[1]} 0 100, 1 150 -r 200
force {SW[2]} 0 200, 1 250 -r 300
force {SW[3]} 0 300, 1 350 -r 400
force {SW[4]} 0 400, 1 450 -r 500
force {SW[5]} 0 500, 1 550 -r 600
force {SW[6]} 0 600, 1 650 -r 700

force {SW[7]} 0 0, 1 100 -r 200
force {SW[8]} 0 0, 1 200 -r 400
force {SW[9]} 0 0, 1 400 -r 700
run 700ns