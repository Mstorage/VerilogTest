`timescale 1ns/1ps
// ============================================================================
// 题目：查表式正弦波发生器
// 难度：★★★★★☆
// 编号：07_arithmetic_dsp/07_lut_sine_generator
//
// 要求：相位累加器驱动 ROM，支持频率控制字、象限映射和输出量化。
//
// 建议参数：PHASE_WIDTH=24、OUT_WIDTH=16、ADDR_WIDTH=10
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  1                en
//   - input  PHASE_WIDTH      phase_inc
//   - output OUT_WIDTH        sine
//   - output PHASE_WIDTH      phase
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=07_arithmetic_dsp/07_lut_sine_generator；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module lut_sine_generator #(
    parameter integer PHASE_WIDTH = 24,
    parameter integer OUT_WIDTH = 16,
    parameter integer ADDR_WIDTH = 10
) (
    input wire clk,
    input wire rst_n,
    input wire en,
    input wire [PHASE_WIDTH-1:0] phase_inc,
    output reg [OUT_WIDTH-1:0] sine,
    output reg [PHASE_WIDTH-1:0] phase
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
