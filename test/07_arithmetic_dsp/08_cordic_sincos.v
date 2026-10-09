`timescale 1ns/1ps
// ============================================================================
// 题目：CORDIC 三角函数发生器
// 难度：★★★★★☆
// 编号：07_arithmetic_dsp/08_cordic_sincos
//
// 要求：以旋转模式流水或迭代地产生 sin/cos，完成象限预处理和增益补偿。
//
// 建议参数：ANGLE_WIDTH=16、DATA_WIDTH=16、ITERATIONS=16
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  1                in_valid
//   - input  ANGLE_WIDTH      angle
//   - output 1                out_valid
//   - output DATA_WIDTH       sine
//   - output DATA_WIDTH       cosine
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=07_arithmetic_dsp/08_cordic_sincos；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module cordic_sincos #(
    parameter integer ANGLE_WIDTH = 16,
    parameter integer DATA_WIDTH = 16,
    parameter integer ITERATIONS = 16
) (
    input wire clk,
    input wire rst_n,
    input wire in_valid,
    input wire [ANGLE_WIDTH-1:0] angle,
    output reg out_valid,
    output reg [DATA_WIDTH-1:0] sine,
    output reg [DATA_WIDTH-1:0] cosine
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
