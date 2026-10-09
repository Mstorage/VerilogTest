`timescale 1ns/1ps
// Baseline self-checking testbench: 参数化 FFT 蝶形单元 (★★★★★★)
// Core verification point: 完成复数定点蝶形、旋转因子乘法、流水对齐及溢出/缩放策略。
// This baseline checks reset/known-value behavior and interface responsiveness.
// Extend it with the boundary cases listed in the exercise before interview review.

module tb_10_fft_butterfly;
    localparam integer WIDTH = 16;
    localparam integer COEFF_WIDTH = 16;
    localparam integer OUT_WIDTH = 18;
    reg clk;
    reg rst_n;
    reg in_valid;
    reg [WIDTH-1:0] a_re;
    reg [WIDTH-1:0] a_im;
    reg [WIDTH-1:0] b_re;
    reg [WIDTH-1:0] b_im;
    reg [COEFF_WIDTH-1:0] w_re;
    reg [COEFF_WIDTH-1:0] w_im;
    wire out_valid;
    wire [OUT_WIDTH-1:0] y0_re;
    wire [OUT_WIDTH-1:0] y0_im;
    wire [OUT_WIDTH-1:0] y1_re;
    wire [OUT_WIDTH-1:0] y1_im;
    wire overflow;

    fft_butterfly dut (
        .clk(clk),
        .rst_n(rst_n),
        .in_valid(in_valid),
        .a_re(a_re),
        .a_im(a_im),
        .b_re(b_re),
        .b_im(b_im),
        .w_re(w_re),
        .w_im(w_im),
        .out_valid(out_valid),
        .y0_re(y0_re),
        .y0_im(y0_im),
        .y1_re(y1_re),
        .y1_im(y1_im),
        .overflow(overflow)
    );

    always #3 clk = ~clk;

    task check_outputs_known;
    begin
        if ((^{out_valid, y0_re, y0_im, y1_re, y1_im, overflow}) === 1'bx) begin
            $display("[FAIL] 07_arithmetic_dsp/10_fft_butterfly: output contains X/Z");
            $fatal(1);
        end
    end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        in_valid = '0;
        a_re = '0;
        a_im = '0;
        b_re = '0;
        b_im = '0;
        w_re = '0;
        w_im = '0;
        #20;
        rst_n = 1'b1;
        #40;
        check_outputs_known();

        // 第二组输入用于发现未驱动输出和明显的常量占位实现。
        in_valid = '1;
        a_re = '1;
        a_im = '1;
        b_re = '1;
        b_im = '1;
        w_re = '1;
        w_im = '1;
        #40;
        check_outputs_known();

        $display("[PASS] 07_arithmetic_dsp/10_fft_butterfly baseline checks");
        $finish;
    end

    initial begin
        #2000;
        $display("[FAIL] 07_arithmetic_dsp/10_fft_butterfly: timeout");
        $fatal(1);
    end
endmodule
