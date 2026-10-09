`timescale 1ns/1ps
// ============================================================================
// 题目：绝对值与饱和运算单元
// 难度：★★☆☆☆☆
// 编号：07_arithmetic_dsp/02_abs_saturating
//
// 要求：正确处理最小负数，并实现定点加法的上下限饱和。
//
// 建议参数：WIDTH=16
// 端口列表（方向 / 位宽 / 名称）：
//   - input  WIDTH            value
//   - input  WIDTH            add_a
//   - input  WIDTH            add_b
//   - output WIDTH            abs_value
//   - output WIDTH            sat_sum
//   - output 1                saturated
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=07_arithmetic_dsp/02_abs_saturating；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module abs_saturating #(
    parameter integer WIDTH = 16
) (
    input wire [WIDTH-1:0] value,
    input wire [WIDTH-1:0] add_a,
    input wire [WIDTH-1:0] add_b,
    output reg [WIDTH-1:0] abs_value,
    output reg [WIDTH-1:0] sat_sum,
    output reg saturated
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
