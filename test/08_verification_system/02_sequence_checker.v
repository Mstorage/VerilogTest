`timescale 1ns/1ps
// ============================================================================
// 题目：序列检测器随机验证
// 难度：★★★☆☆☆
// 编号：08_verification_system/02_sequence_checker
//
// 要求：用参考模型检查重叠匹配，并收集关键状态转移覆盖。
//
// 建议参数：PATTERN=11、PATTERN_LEN=4
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  1                bit_valid
//   - input  1                bit_in
//   - input  1                observed_detect
//   - output 1                error
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=08_verification_system/02_sequence_checker；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module sequence_checker #(
    parameter integer PATTERN = 11,
    parameter integer PATTERN_LEN = 4
) (
    input wire clk,
    input wire rst_n,
    input wire bit_valid,
    input wire bit_in,
    input wire observed_detect,
    output reg error
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
