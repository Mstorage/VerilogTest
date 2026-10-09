`timescale 1ns/1ps
// ============================================================================
// 题目：流水乘加器（MAC）
// 难度：★★★★☆☆
// 编号：07_arithmetic_dsp/05_pipelined_mac
//
// 要求：支持连续输入、固定延迟和清零/饱和，合理放置流水寄存器。
//
// 建议参数：A_WIDTH=16、B_WIDTH=16、ACC_WIDTH=40
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  1                valid_in
//   - input  1                clear_acc
//   - input  A_WIDTH          a
//   - input  B_WIDTH          b
//   - output 1                valid_out
//   - output ACC_WIDTH        acc
//   - output 1                overflow
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=07_arithmetic_dsp/05_pipelined_mac；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module pipelined_mac #(
    parameter integer A_WIDTH = 16,
    parameter integer B_WIDTH = 16,
    parameter integer ACC_WIDTH = 40
) (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire clear_acc,
    input wire [A_WIDTH-1:0] a,
    input wire [B_WIDTH-1:0] b,
    output reg valid_out,
    output reg [ACC_WIDTH-1:0] acc,
    output reg overflow
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
