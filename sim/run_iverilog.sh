#!/bin/bash
# ========================================================
# Run Icarus Verilog Simulation for secded_ram
# ========================================================

# Compile all source files and testbenches
iverilog -o tb.vvp \
    tb/tb_ecc_ram.v \
    examples/fpga_tb.v \
    src/ecc_ram.v \
    src/ecc_secded.v \
    examples/fpga_top.v

# Run the simulation
vvp tb.vvp

# Generate waveform file (optional)
# For GTKWave: vvp tb.vvp -lxt2 && gtkwave tb.lxt2
