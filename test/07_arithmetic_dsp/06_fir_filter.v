`timescale 1ns/1ps
// ============================================================================
// 题目：可配置 FIR 滤波器
// 难度：★★★★☆☆
// 编号：07_arithmetic_dsp/06_fir_filter
//
// 要求：实现抽头延迟线、定点乘加、系数装载，并处理位宽增长与舍入。
//
// 建议参数：DATA_WIDTH=16、COEFF_WIDTH=16、TAPS=8、OUT_WIDTH=36
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  1                sample_valid
//   - input  DATA_WIDTH       sample
//   - input  1                coeff_we
//   - input  TAPS*COEFF_WIDTH coeffs
//   - output 1                result_valid
//   - output OUT_WIDTH        result
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=07_arithmetic_dsp/06_fir_filter；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module fir_filter #(
    parameter integer DATA_WIDTH = 16,
    parameter integer COEFF_WIDTH = 16,
    parameter integer TAPS = 8,
    parameter integer OUT_WIDTH = 36
) (
    input wire clk,
    input wire rst_n,
    input wire sample_valid,
    input wire [DATA_WIDTH-1:0] sample,
    input wire coeff_we,
    input wire [TAPS*COEFF_WIDTH-1:0] coeffs,
    output reg result_valid,
    output reg [OUT_WIDTH-1:0] result
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
