`timescale 1ns/1ps
// ============================================================================
// 题目：交通灯控制器
// 难度：★★☆☆☆☆
// 编号：02_timing_fsm/04_traffic_light
//
// 要求：使用 Moore FSM 实现定时状态切换、紧急模式和安全复位状态。
//
// 建议参数：GREEN_CYCLES=10、YELLOW_CYCLES=3、RED_CYCLES=10
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  1                emergency
//   - output 3                light_a
//   - output 3                light_b
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=02_timing_fsm/04_traffic_light；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module traffic_light #(
    parameter integer GREEN_CYCLES = 10,
    parameter integer YELLOW_CYCLES = 3,
    parameter integer RED_CYCLES = 10
) (
    input wire clk,
    input wire rst_n,
    input wire emergency,
    output reg [3-1:0] light_a,
    output reg [3-1:0] light_b
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
