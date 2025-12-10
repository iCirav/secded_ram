# secded_ram

Reliable ECC-protected RAM (Single Error Correct, Double Error Detect) in Verilog.  
Supports 8-bit and 16-bit word widths and is ready for FPGA or ASIC integration.

---

## Features

- Configurable **8-bit or 16-bit word widths**
- **SECDED (Hamming ECC)** for single-bit correction and double-bit detection
- Predefined RAM depth (configurable via parameter)
- **CPU-style interface** via top-level FPGA wrapper
- Includes:
  - RAM module (`ecc_ram.v`)
  - ECC module (`ecc_secded.v`)
  - FPGA wrapper (`fpga_top.v`)
  - Testbench (`tb_ecc_ram.v`, `fpga_tb.v`)
- Ready for **simulation and synthesis** on FPGA or ASIC

---

## Directory Structure
```
secded_ram/
├── src/ # Verilog source files
│ ├── ecc_ram.v
│ └── ecc_secded.v
├── tb/ # Testbenches
│ ├── tb_ecc_ram.v
│ └── tb_helpers.v
├── examples/ # FPGA top-level wrapper and example simulation
│ ├── fpga_top.v
│ └── fpga_tb.v
├── sim/ # Simulation scripts (Icarus Verilog, ModelSim)
│ ├── run_iverilog.sh
│ └── run_modelsim.do
├── doc/ # Documentation
│ ├── ecc_algorithm.md
│ └── memory_map.md
├── LICENSE
└── README.md
```

---

## Usage

### 1. Synthesis / FPGA Integration

Include `ecc_ram.v` or `fpga_top.v` in your FPGA or ASIC project. Configure parameters as needed:

```verilog
ecc_ram #(
    .DATA_WIDTH(8),
    .RAM_DEPTH(256)
) my_ram (
    .clk(clk),
    .rst(rst),
    .data_in(data_in),
    .addr(addr),
    .write_en(write_en),
    .read_en(read_en),
    .data_out(data_out),
    .single_bit_error(single_error),
    .double_bit_error(double_error)
);
```

### Simulation

Run the included testbench:

```bash
# Compile testbench and source files
iverilog -o tb.vvp tb/tb_ecc_ram.v src/ecc_ram.v src/ecc_secded.v

# Run simulation
vvp tb.vvp
```

The FPGA wrapper (fpga_top.v) provides a CPU-style interface. Use fpga_tb.v to simulate:
```bash
iverilog -o fpga_tb.vvp examples/fpga_tb.v src/ecc_ram.v src/ecc_secded.v examples/fpga_top.v
vvp fpga_tb.vvp
```

---

## Disclaimer
This HDL design is provided "AS IS", without warranty of any kind.  
It has not been validated for safety-critical or production use.
Users are responsible for verifying correct operation in their application.

---

## License
This project is licensed under the Apache-2.0 License.  
See the [LICENSE](LICENSE) file for details.

All source files contain SPDX license identifiers.
