`timescale 1ns/1ps
module fpga_tb;

    localparam DATA_WIDTH = 16;
    localparam RAM_DEPTH  = 64;
    localparam CLK_PERIOD = 10;

    reg clk, rst;
    reg [DATA_WIDTH-1:0] cpu_data_in;
    reg [$clog2(RAM_DEPTH)-1:0] cpu_addr;
    reg cpu_write_en, cpu_read_en;
    wire [DATA_WIDTH-1:0] cpu_data_out;
    wire ecc_single_error, ecc_double_error;

    fpga_top #(.DATA_WIDTH(DATA_WIDTH), .RAM_DEPTH(RAM_DEPTH)) dut (
        .clk(clk),
        .rst(rst),
        .cpu_data_in(cpu_data_in),
        .cpu_addr(cpu_addr),
        .cpu_write_en(cpu_write_en),
        .cpu_read_en(cpu_read_en),
        .cpu_data_out(cpu_data_out),
        .ecc_single_error(ecc_single_error),
        .ecc_double_error(ecc_double_error)
    );

    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

    initial begin
        rst = 1; cpu_write_en = 0; cpu_read_en = 0; cpu_data_in = 0; cpu_addr = 0;
        #(2*CLK_PERIOD);
        rst = 0;

        $display("FPGA Top-Level ECC RAM Testbench");

        // Simple write/read test
        cpu_addr = 5; cpu_data_in = 16'hA5A5;
        cpu_write_en = 1; #(CLK_PERIOD);
        cpu_write_en = 0;

        cpu_read_en = 1; #(CLK_PERIOD);
        cpu_read_en = 0;
        $display("Read back addr=5: %h", cpu_data_out);

        // Inject single-bit error manually
        // (simulation only, overwrite internal RAM)
        dut.ram_inst.ram_data[5][0] = ~dut.ram_inst.ram_data[5][0];
        cpu_read_en = 1; #(CLK_PERIOD); cpu_read_en = 0;
        $display("After single-bit flip: data=%h, SECDED=%b/%b",
                 cpu_data_out, ecc_single_error, ecc_double_error);

        // Inject double-bit error
        dut.ram_inst.ram_data[5][1] = ~dut.ram_inst.ram_data[5][1];
        cpu_read_en = 1; #(CLK_PERIOD); cpu_read_en = 0;
        $display("After double-bit flip: data=%h, SECDED=%b/%b",
                 cpu_data_out, ecc_single_error, ecc_double_error);

        $stop;
    end

endmodule
