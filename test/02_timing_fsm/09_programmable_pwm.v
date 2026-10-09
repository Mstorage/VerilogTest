`timescale 1ns/1ps
// ============================================================================
// 题目：可编程 PWM
// 难度：★★★★☆☆
// 编号：02_timing_fsm/09_programmable_pwm
//
// 要求：支持周期和占空比更新，要求更新只在周期边界生效且输出无毛刺。
//
// 建议参数：WIDTH=8
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  1                cfg_valid
//   - input  WIDTH            period
//   - input  WIDTH            duty
//   - output 1                pwm
//   - output 1                cfg_ready
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=02_timing_fsm/09_programmable_pwm；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module programmable_pwm #(
    parameter integer WIDTH = 8
) (
    input wire clk,
    input wire rst_n,
    input wire cfg_valid,
    input wire [WIDTH-1:0] period,
    input wire [WIDTH-1:0] duty,
    output reg pwm,
    output reg cfg_ready
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
