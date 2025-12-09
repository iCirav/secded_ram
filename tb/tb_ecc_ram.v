`timescale 1ns/1ps

module tb_ecc_ram;

    // Parameters
    localparam RAM_DEPTH = 64;
    localparam CLK_PERIOD = 10;

    reg clk, rst;
    reg write_en, read_en;
    reg [15:0] data_in;
    reg [5:0] addr;
    wire [15:0] data_out;
    wire single_bit_error, double_bit_error;

    integer i,b;
    reg [15:0] mem_model [0:RAM_DEPTH-1];
    reg [15:0] corrupted;

    // Clock
    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

    // DUT Instance (8-bit)
    ecc_ram #(.DATA_WIDTH(8), .RAM_DEPTH(RAM_DEPTH)) dut8 (
        .clk(clk), .rst(rst),
        .data_in(data_in[7:0]), .addr(addr),
        .write_en(write_en), .read_en(read_en),
        .data_out(data_out[7:0]),
        .single_bit_error(single_bit_error),
        .double_bit_error(double_bit_error)
    );

    // DUT Instance (16-bit)
    ecc_ram #(.DATA_WIDTH(16), .RAM_DEPTH(RAM_DEPTH)) dut16 (
        .clk(clk), .rst(rst),
        .data_in(data_in), .addr(addr),
        .write_en(write_en), .read_en(read_en),
        .data_out(data_out),
        .single_bit_error(single_bit_error),
        .double_bit_error(double_bit_error)
    );

    initial begin
        rst = 1; write_en = 0; read_en = 0; data_in = 0; addr = 0;
        #(2*CLK_PERIOD);
        rst = 0;

        $display("Running ECC RAM Testbench");

        // Run ECC test for 8-bit
        test_ecc(8);

        // Run ECC test for 16-bit
        test_ecc(16);

        $display("ECC RAM Testbench finished");
        $stop;
    end

    task test_ecc;
        input integer dw;
        reg [15:0] test_data;
        begin
            $display("Testing %0d-bit RAM", dw);

            // Fill RAM
            for (i=0;i<RAM_DEPTH;i=i+1) begin
                addr = i;
                test_data = $random;
                if (dw==8) data_in = test_data[7:0]; else data_in = test_data;
                write_en = 1; read_en = 0;
                #(CLK_PERIOD);
                write_en = 0;
                mem_model[i] = test_data;
            end

            // Read and verify
            for (i=0;i<RAM_DEPTH;i=i+1) begin
                addr = i; read_en = 1; #(CLK_PERIOD); read_en = 0;
                if (data_out !== mem_model[i][dw-1:0])
                    $display("ERROR: Read mismatch at addr=%0d", i);
            end

            // Single-bit error injection
            for (i=0;i<RAM_DEPTH;i=i+1) begin
                addr = i; read_en = 1; #(CLK_PERIOD); read_en = 0;
                corrupted = data_out;
                b = $urandom_range(0,dw-1);
                corrupted[b] = ~corrupted[b];
                data_out = corrupted; read_en = 1; #(CLK_PERIOD); read_en = 0;
                if (!single_bit_error) $display("ERROR: Single-bit not detected at addr=%0d", i);
                if (data_out !== mem_model[i][dw-1:0])
                    $display("ERROR: Single-bit correction failed at addr=%0d", i);
            end

            // Double-bit error injection
            for (i=0;i<RAM_DEPTH;i=i+1) begin
                addr = i; read_en = 1; #(CLK_PERIOD); read_en = 0;
                corrupted = data_out;
                b = $urandom_range(0,dw-1); corrupted[b] = ~corrupted[b];
                b = $urandom_range(0,dw-1); corrupted[b] = ~corrupted[b];
                data_out = corrupted; read_en = 1; #(CLK_PERIOD); read_en = 0;
                if (!double_bit_error) $display("ERROR: Double-bit not detected at addr=%0d", i);
            end
        end
    endtask

endmodule
