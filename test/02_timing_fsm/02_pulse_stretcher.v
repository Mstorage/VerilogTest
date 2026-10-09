`timescale 1ns/1ps
// ============================================================================
// 题目：脉冲展宽与可重触发单稳态
// 难度：★★☆☆☆☆
// 编号：02_timing_fsm/02_pulse_stretcher
//
// 要求：将单周期输入展宽为 M 周期，并定义展宽期间再次触发的行为。
//
// 建议参数：LENGTH=4、COUNT_WIDTH=3
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  1                trigger
//   - input  1                retrigger_en
//   - output 1                pulse_out
//   - output 1                busy
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=02_timing_fsm/02_pulse_stretcher；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module pulse_stretcher #(
    parameter integer LENGTH = 4,
    parameter integer COUNT_WIDTH = 3
) (
    input wire clk,
    input wire rst_n,
    input wire trigger,
    input wire retrigger_en,
    output reg pulse_out,
    output reg busy
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
