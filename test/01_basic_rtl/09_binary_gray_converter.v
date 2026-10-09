`timescale 1ns/1ps
// ============================================================================
// 题目：二进制、独热码、格雷码互转
// 难度：★★☆☆☆☆
// 编号：01_basic_rtl/09_binary_gray_converter
//
// 要求：实现组合转换器，并验证相邻格雷码仅一位变化。
//
// 建议参数：WIDTH=8
// 端口列表（方向 / 位宽 / 名称）：
//   - input  WIDTH            bin
//   - input  WIDTH            gray_in
//   - output WIDTH            gray
//   - output WIDTH            bin_out
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=01_basic_rtl/09_binary_gray_converter；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module binary_gray_converter #(
    parameter integer WIDTH = 8
) (
    input wire [WIDTH-1:0] bin,
    input wire [WIDTH-1:0] gray_in,
    output reg [WIDTH-1:0] gray,
    output reg [WIDTH-1:0] bin_out
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
