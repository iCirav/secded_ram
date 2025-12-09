# ========================================================
# Run ModelSim Simulation for secded_ram
# ========================================================
vlib work
vlog src/ecc_ram.v src/ecc_secded.v examples/fpga_top.v tb/tb_ecc_ram.v examples/fpga_tb.v

# Load the top-level testbench
vsim work.tb_ecc_ram

# Run simulation
run -all

# Optionally dump waves for viewing
# vsim -do "add wave *; run -all; quit"
quit
