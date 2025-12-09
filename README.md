# secded_ram

Reliable RAM with SECDED (Single Error Correct, Double Error Detect) protection.

## Features

- Configurable 8-bit or 16-bit word width
- Predefined RAM depth
- SECDED Hamming ECC for single-bit correction and double-bit detection
- Fully synchronous, ready for FPGA or ASIC
- Includes testbench with error injection

## Directory Structure

- `src/` – Verilog source files
- `tb/` – Testbenches for simulation
- `sim/` – Simulation scripts (ModelSim, Icarus Verilog)
- `doc/` – Documentation and algorithm explanation
- `examples/` – Top-level FPGA wrapper examples

## Usage

### Synthesis

Include `ecc_ram.v` in your FPGA/ASIC project. Configure `DATA_WIDTH` and `RAM_DEPTH` parameters as needed.

### Simulation

Run the included testbench:

```bash
iverilog -o tb_ecc_ram.vvp tb/tb_ecc_ram.v src/ecc_ram.v
vvp tb_ecc_ram.vvp
