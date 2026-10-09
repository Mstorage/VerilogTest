`timescale 1ns/1ps
// ============================================================================
// 题目：按键消抖器
// 难度：★★☆☆☆☆
// 编号：02_timing_fsm/03_debouncer
//
// 要求：输入先同步，再通过连续稳定计数输出电平和单次按下脉冲。
//
// 建议参数：STABLE_CYCLES=8、COUNT_WIDTH=3
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  1                async_in
//   - output 1                level
//   - output 1                pressed
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=02_timing_fsm/03_debouncer；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module debouncer #(
    parameter integer STABLE_CYCLES = 8,
    parameter integer COUNT_WIDTH = 3
) (
    input wire clk,
    input wire rst_n,
    input wire async_in,
    output reg level,
    output reg pressed
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
