`timescale 1ns/1ps
// ============================================================================
// 题目：任意可配置序列检测器
// 难度：★★★☆☆☆
// 编号：02_timing_fsm/06_configurable_sequence
//
// 要求：通过移位比较或 KMP 风格状态机检测参数化模式，支持重叠。
//
// 建议参数：PATTERN=11、PATTERN_LEN=4
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  1                bit_in
//   - input  1                valid_in
//   - output 1                detected
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=02_timing_fsm/06_configurable_sequence；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module configurable_sequence #(
    parameter integer PATTERN = 11,
    parameter integer PATTERN_LEN = 4
) (
    input wire clk,
    input wire rst_n,
    input wire bit_in,
    input wire valid_in,
    output reg detected
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
