`timescale 1ns/1ps
// ============================================================================
// 题目：无毛刺时钟切换控制器
// 难度：★★★☆☆☆
// 编号：02_timing_fsm/08_glitch_free_clock_mux
//
// 要求：在两个时钟源间安全切换，避免输出窄脉冲；解释适用假设。
//
// 建议参数：无
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk0
//   - input  1                clk1
//   - input  1                rst_n
//   - input  1                sel
//   - output 1                clk_out
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=02_timing_fsm/08_glitch_free_clock_mux；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module glitch_free_clock_mux (
    input wire clk0,
    input wire clk1,
    input wire rst_n,
    input wire sel,
    output reg clk_out
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
