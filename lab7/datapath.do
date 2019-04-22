vlib work
vlog -timescale 1ns/1ns part2.v
vsim datapath
log {/*}
add wave {/*}

force {clock} 0 0, 1 1 -r 2

force {reset} 1
force {colour[2:0]} 110
force {pos[6:0]} 0011011
force {ld_x} 1
force {ld_y} 0
force {alu_op_x} 1
force {alu_op_y} 1
run 10

force {reset} 0
run 2
force {reset} 1
force {colour[2:0]} 111
force {pos[6:0]} 0001110
force {ld_x} 0
force {ld_y} 1
force {alu_op_x} 1
force {alu_op_y} 0
run 10
