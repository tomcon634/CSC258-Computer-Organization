vlib work
vlog -timescale 1ns/1ns ram32x4.v
vsim -L altera_mf_ver ram32x4
log {/*}
add wave {/*}


force {clock} 0 0, 1 1 -r 2

force {wren} 1
force {address[4:0]} 00000
force {data[3:0]} 1100
run 100

force {address[4:0]} 00001
force {data[3:0]} 1101
run 100

force {wren} 0
force {address[4:0]} 00010
force {data[3:0]} 0010
run 100

force {address[4:0]} 00000
run 100

force {address[4:0]} 00001
run 100