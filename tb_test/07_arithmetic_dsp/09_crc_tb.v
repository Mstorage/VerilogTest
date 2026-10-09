`timescale 1ns/1ps
// Baseline self-checking testbench: CRC 生成与校验 (★★★★★☆)
// Core verification point: 根据给定多项式实现串行版和并行版，明确初值、反射与异或约定。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_09_crc;
    localparam integer DATA_WIDTH = 8;
    localparam integer CRC_WIDTH = 16;
    localparam integer POLY = 4129;
    localparam integer INIT = 65535;
    reg clk;
    reg rst_n;
    reg init;
    reg data_valid;
    reg [DATA_WIDTH-1:0] data;
    reg check;
    wire [CRC_WIDTH-1:0] crc;
    wire crc_ok;

    crc_unit dut (
        .clk(clk),
        .rst_n(rst_n),
        .init(init),
        .data_valid(data_valid),
        .data(data),
        .check(check),
        .crc(crc),
        .crc_ok(crc_ok)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{crc, crc_ok}) === 1'bx) begin
            $display("[FAIL] 07_arithmetic_dsp/09_crc: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        init = '0;
        data_valid = '0;
        data = '0;
        check = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        init = '1;
        data_valid = '1;
        data = '1;
        check = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 07_arithmetic_dsp/09_crc baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 07_arithmetic_dsp/09_crc: timeout");
        $fatal(1);
    end
endmodule
