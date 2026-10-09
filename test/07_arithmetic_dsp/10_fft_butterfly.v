`timescale 1ns/1ps
// ============================================================================
// 题目：参数化 FFT 蝶形单元
// 难度：★★★★★★
// 编号：07_arithmetic_dsp/10_fft_butterfly
//
// 要求：完成复数定点蝶形、旋转因子乘法、流水对齐及溢出/缩放策略。
//
// 建议参数：WIDTH=16、COEFF_WIDTH=16、OUT_WIDTH=18
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  1                in_valid
//   - input  WIDTH            a_re
//   - input  WIDTH            a_im
//   - input  WIDTH            b_re
//   - input  WIDTH            b_im
//   - input  COEFF_WIDTH      w_re
//   - input  COEFF_WIDTH      w_im
//   - output 1                out_valid
//   - output OUT_WIDTH        y0_re
//   - output OUT_WIDTH        y0_im
//   - output OUT_WIDTH        y1_re
//   - output OUT_WIDTH        y1_im
//   - output 1                overflow
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=07_arithmetic_dsp/10_fft_butterfly；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module fft_butterfly #(
    parameter integer WIDTH = 16,
    parameter integer COEFF_WIDTH = 16,
    parameter integer OUT_WIDTH = 18
) (
    input wire clk,
    input wire rst_n,
    input wire in_valid,
    input wire [WIDTH-1:0] a_re,
    input wire [WIDTH-1:0] a_im,
    input wire [WIDTH-1:0] b_re,
    input wire [WIDTH-1:0] b_im,
    input wire [COEFF_WIDTH-1:0] w_re,
    input wire [COEFF_WIDTH-1:0] w_im,
    output reg out_valid,
    output reg [OUT_WIDTH-1:0] y0_re,
    output reg [OUT_WIDTH-1:0] y0_im,
    output reg [OUT_WIDTH-1:0] y1_re,
    output reg [OUT_WIDTH-1:0] y1_im,
    output reg overflow
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
