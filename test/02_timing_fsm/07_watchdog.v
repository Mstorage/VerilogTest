`timescale 1ns/1ps
// ============================================================================
// 题目：超时监视器（watchdog）
// 难度：★★★☆☆☆
// 编号：02_timing_fsm/07_watchdog
//
// 要求：收到喂狗事件清零，否则到期报警；加入暂停、清除和锁存报警模式。
//
// 建议参数：TIMEOUT=16、COUNT_WIDTH=4
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  1                kick
//   - input  1                pause
//   - input  1                clear_alarm
//   - input  1                latch_mode
//   - output 1                alarm
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=02_timing_fsm/07_watchdog；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module watchdog #(
    parameter integer TIMEOUT = 16,
    parameter integer COUNT_WIDTH = 4
) (
    input wire clk,
    input wire rst_n,
    input wire kick,
    input wire pause,
    input wire clear_alarm,
    input wire latch_mode,
    output reg alarm
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
