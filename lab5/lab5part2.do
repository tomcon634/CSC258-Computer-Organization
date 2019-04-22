# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in mux.v to working dir;
# could also have multiple verilog files.
vlog counter2.v

# Load simulation using mux as the top level simulation module.
vsim counter2

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}
force {SW[0]} 0
force {SW[1]} 0
force {SW[3]} 1 0, 0 3, 1 11

force {CLOCK_50} 0 0, 1 10 -repeat 20
run 400ns