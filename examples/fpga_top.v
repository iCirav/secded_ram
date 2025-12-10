// Copyright (c) 2025 Joshua Bauer
// SPDX-License-Identifier: Apache-2.0

// ============================================================
// FPGA Top-Level Wrapper for ECC RAM
// Supports 8-bit and 16-bit word widths
// CPU/Peripheral-style interface
// ============================================================
module fpga_top #(
    parameter DATA_WIDTH = 16,    // 8 or 16 bits
    parameter RAM_DEPTH  = 256
)(
    input  wire clk,
    input  wire rst,
    input  wire [DATA_WIDTH-1:0] cpu_data_in,
    input  wire [$clog2(RAM_DEPTH)-1:0] cpu_addr,
    input  wire cpu_write_en,
    input  wire cpu_read_en,
    output wire [DATA_WIDTH-1:0] cpu_data_out,
    output wire ecc_single_error,
    output wire ecc_double_error
);

    // Internal signals
    wire [DATA_WIDTH-1:0] ram_data_out;
    wire single_error, double_error;

    // Instantiate ECC RAM
    ecc_ram #(
        .DATA_WIDTH(DATA_WIDTH),
        .RAM_DEPTH(RAM_DEPTH)
    ) ram_inst (
        .clk(clk),
        .rst(rst),
        .data_in(cpu_data_in),
        .addr(cpu_addr),
        .write_en(cpu_write_en),
        .read_en(cpu_read_en),
        .data_out(ram_data_out),
        .single_bit_error(single_error),
        .double_bit_error(double_error)
    );

    // Output assignments
    assign cpu_data_out     = ram_data_out;
    assign ecc_single_error = single_error;
    assign ecc_double_error = double_error;

endmodule
