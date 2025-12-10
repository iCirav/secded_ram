// Copyright (c) 2025 Joshua Bauer
// SPDX-License-Identifier: Apache-2.0

// ============================================================
// ECC RAM Module for 8/16-bit words with SECDED
// ============================================================
module ecc_ram #(
    parameter DATA_WIDTH = 8,
    parameter RAM_DEPTH  = 256
)(
    input  wire clk,
    input  wire rst,
    input  wire [DATA_WIDTH-1:0] data_in,
    input  wire [$clog2(RAM_DEPTH)-1:0] addr,
    input  wire write_en,
    input  wire read_en,
    output reg [DATA_WIDTH-1:0] data_out,
    output reg single_bit_error,
    output reg double_bit_error
);

    localparam ECC_BITS = (DATA_WIDTH==8)?5:6;

    reg [DATA_WIDTH-1:0] ram_data [0:RAM_DEPTH-1];
    reg [ECC_BITS-1:0]   ram_ecc  [0:RAM_DEPTH-1];

    integer i;

    // --------------------------
    // Hamming parity functions
    // --------------------------
    function [ECC_BITS-2:0] hamming_parity;
        input [DATA_WIDTH-1:0] data;
        integer i,j,pos;
        reg [DATA_WIDTH-1:0] tmp;
        begin
            tmp = data;
            hamming_parity = 0;
            for (j=0;j<ECC_BITS-1;j=j+1) begin
                for (i=0;i<DATA_WIDTH;i=i+1) begin
                    if (((i+1) & (1<<j)) != 0)
                        hamming_parity[j] = hamming_parity[j] ^ tmp[i];
                end
            end
        end
    endfunction

    function global_parity;
        input [DATA_WIDTH-1:0] data;
        input [ECC_BITS-2:0] parity_bits;
        integer idx;
        reg tmp;
        begin
            tmp = 0;
            for (idx=0; idx<DATA_WIDTH; idx=idx+1)
                tmp = tmp ^ data[idx];
            for (idx=0; idx<ECC_BITS-1; idx=idx+1)
                tmp = tmp ^ parity_bits[idx];
            global_parity = tmp;
        end
    endfunction

    // --------------------------
    // Write with ECC
    // --------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i=0;i<RAM_DEPTH;i=i+1) begin
                ram_data[i] <= 0;
                ram_ecc[i]  <= 0;
            end
        end else if (write_en) begin
            reg [ECC_BITS-2:0] p;
            reg g;
            p = hamming_parity(data_in);
            g = global_parity(data_in,p);
            ram_data[addr] <= data_in;
            ram_ecc[addr]  <= {g,p};
        end
    end

    // --------------------------
    // Read and ECC decode
    // --------------------------
    always @(posedge clk) begin
        if (read_en) begin
            reg [DATA_WIDTH-1:0] d_in;
            reg [ECC_BITS-1:0] e_in;
            reg [ECC_BITS-2:0] p_calc, p_in, syndrome;
            reg g_calc, g_in;
            integer bitpos;

            d_in = ram_data[addr];
            e_in = ram_ecc[addr];

            g_in = e_in[ECC_BITS-1];
            p_in = e_in[ECC_BITS-2:0];

            p_calc = hamming_parity(d_in);
            g_calc = global_parity(d_in,p_calc);

            syndrome = p_calc ^ p_in;

            if (syndrome==0 && g_calc==g_in) begin
                data_out <= d_in;
                single_bit_error <= 0;
                double_bit_error <= 0;
            end else if (syndrome!=0 && g_calc!=g_in) begin
                bitpos = 0;
                for (i=0;i<ECC_BITS-1;i=i+1)
                    if (syndrome[i])
                        bitpos = bitpos + (1<<i);
                if (bitpos>0 && bitpos<=DATA_WIDTH)
                    d_in[bitpos-1] = ~d_in[bitpos-1];
                data_out <= d_in;
                single_bit_error <= 1;
                double_bit_error <= 0;
            end else begin
                data_out <= d_in;
                single_bit_error <= 0;
                double_bit_error <= 1;
            end
        end
    end

endmodule
