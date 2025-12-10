// Copyright (c) 2025 Joshua Bauer
// SPDX-License-Identifier: Apache-2.0

// ============================================================
// ECC SECDED Module (Hamming)
// Single Error Correct, Double Error Detect
// ============================================================
module ecc_secded #(
    parameter DATA_WIDTH = 8   // 8 or 16
)(
    input  wire [DATA_WIDTH-1:0] data_in,
    output wire [((DATA_WIDTH==8)?5:6)-1:0] ecc_out
);

    localparam ECC_BITS = (DATA_WIDTH==8)?5:6;

    integer i, j, pos;
    reg [ECC_BITS-2:0] p;
    reg g;

    always @(*) begin
        // Hamming parity
        p = 0;
        for (j=0;j<ECC_BITS-1;j=j+1) begin
            for (i=0;i<DATA_WIDTH;i=i+1) begin
                if (((i+1) & (1<<j)) != 0)
                    p[j] = p[j] ^ data_in[i];
            end
        end

        // Global parity
        g = 0;
        for (i=0;i<DATA_WIDTH;i=i+1)
            g = g ^ data_in[i];
        for (i=0;i<ECC_BITS-1;i=i+1)
            g = g ^ p[i];
    end

    assign ecc_out = {g, p};

endmodule
