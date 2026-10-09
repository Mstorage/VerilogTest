`timescale 1ns/1ps
// ============================================================================
// 题目：迭代乘法器
// 难度：★★★☆☆☆
// 编号：07_arithmetic_dsp/03_iterative_multiplier
//
// 要求：用移位加法完成有符号乘法，提供 start/busy/done 握手。
//
// 建议参数：WIDTH=16
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  1                start
//   - input  1                signed_mode
//   - input  WIDTH            a
//   - input  WIDTH            b
//   - output 1                busy
//   - output 1                done
//   - output 2*WIDTH          product
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=07_arithmetic_dsp/03_iterative_multiplier；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module iterative_multiplier #(
    parameter integer WIDTH = 16
) (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire signed_mode,
    input wire [WIDTH-1:0] a,
    input wire [WIDTH-1:0] b,
    output reg busy,
    output reg done,
    output reg [2*WIDTH-1:0] product
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
