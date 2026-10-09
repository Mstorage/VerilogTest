`timescale 1ns/1ps
// ============================================================================
// 题目：前导零计数器（LZC）
// 难度：★★★☆☆☆
// 编号：01_basic_rtl/11_leading_zero_counter
//
// 要求：输出前导零个数；din=0 时 valid=0 且 count=WIDTH，否则 valid=1。
//
// 建议参数：WIDTH=32、COUNT_WIDTH=6
// 端口列表（方向 / 位宽 / 名称）：
//   - input  WIDTH            din
//   - output COUNT_WIDTH      count
//   - output 1                valid
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=01_basic_rtl/11_leading_zero_counter；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module leading_zero_counter #(
    parameter integer WIDTH = 32,
    parameter integer COUNT_WIDTH = 6
) (
    input wire [WIDTH-1:0] din,
    output reg [COUNT_WIDTH-1:0] count,
    output reg valid
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
