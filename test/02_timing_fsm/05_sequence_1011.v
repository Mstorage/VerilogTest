`timescale 1ns/1ps
// ============================================================================
// 题目：`1011` 序列检测器
// 难度：★★☆☆☆☆
// 编号：02_timing_fsm/05_sequence_1011
//
// 要求：分别实现允许重叠/不允许重叠检测，并比较 Mealy 与 Moore 输出延迟。
//
// 建议参数：ALLOW_OVERLAP=1
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
//   3. 执行 make run Q=02_timing_fsm/05_sequence_1011；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module sequence_1011 #(
    parameter integer ALLOW_OVERLAP = 1
) (
    input wire clk,
    input wire rst_n,
    input wire bit_in,
    input wire valid_in,
    output reg detected
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
