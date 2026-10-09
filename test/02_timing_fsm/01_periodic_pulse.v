`timescale 1ns/1ps
// ============================================================================
// 题目：周期脉冲发生器
// 难度：★☆☆☆☆☆
// 编号：02_timing_fsm/01_periodic_pulse
//
// 要求：每 N 个时钟产生一个单周期脉冲，N 可参数化且无累计偏差。
//
// 建议参数：PERIOD=10、COUNT_WIDTH=4
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  1                en
//   - output 1                pulse
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=02_timing_fsm/01_periodic_pulse；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module periodic_pulse #(
    parameter integer PERIOD = 10,
    parameter integer COUNT_WIDTH = 4
) (
    input wire clk,
    input wire rst_n,
    input wire en,
    output reg pulse
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
