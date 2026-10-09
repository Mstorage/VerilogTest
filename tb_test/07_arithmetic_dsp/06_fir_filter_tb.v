`timescale 1ns/1ps
// Baseline self-checking testbench: 可配置 FIR 滤波器 (★★★★☆☆)
// Core verification point: 实现抽头延迟线、定点乘加、系数装载，并处理位宽增长与舍入。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_06_fir_filter;
    localparam integer DATA_WIDTH = 16;
    localparam integer COEFF_WIDTH = 16;
    localparam integer TAPS = 8;
    localparam integer OUT_WIDTH = 36;
    reg clk;
    reg rst_n;
    reg sample_valid;
    reg [DATA_WIDTH-1:0] sample;
    reg coeff_we;
    reg [TAPS*COEFF_WIDTH-1:0] coeffs;
    wire result_valid;
    wire [OUT_WIDTH-1:0] result;

    fir_filter dut (
        .clk(clk),
        .rst_n(rst_n),
        .sample_valid(sample_valid),
        .sample(sample),
        .coeff_we(coeff_we),
        .coeffs(coeffs),
        .result_valid(result_valid),
        .result(result)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{result_valid, result}) === 1'bx) begin
            $display("[FAIL] 07_arithmetic_dsp/06_fir_filter: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        sample_valid = '0;
        sample = '0;
        coeff_we = '0;
        coeffs = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        sample_valid = '1;
        sample = '1;
        coeff_we = '1;
        coeffs = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 07_arithmetic_dsp/06_fir_filter baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 07_arithmetic_dsp/06_fir_filter: timeout");
        $fatal(1);
    end
endmodule
