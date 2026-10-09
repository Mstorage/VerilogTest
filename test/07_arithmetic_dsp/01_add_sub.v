`timescale 1ns/1ps
// ============================================================================
// 题目：参数化加减器
// 难度：★★☆☆☆☆
// 编号：07_arithmetic_dsp/01_add_sub
//
// 要求：支持有/无符号运算，输出进位、借位、零和有符号溢出标志。
//
// 建议参数：WIDTH=16
// 端口列表（方向 / 位宽 / 名称）：
//   - input  WIDTH            a
//   - input  WIDTH            b
//   - input  1                sub
//   - input  1                signed_mode
//   - output WIDTH            result
//   - output 1                carry_borrow
//   - output 1                zero
//   - output 1                overflow
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=07_arithmetic_dsp/01_add_sub；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module add_sub #(
    parameter integer WIDTH = 16
) (
    input wire [WIDTH-1:0] a,
    input wire [WIDTH-1:0] b,
    input wire sub,
    input wire signed_mode,
    output reg [WIDTH-1:0] result,
    output reg carry_borrow,
    output reg zero,
    output reg overflow
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
