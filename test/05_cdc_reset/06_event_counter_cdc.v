`timescale 1ns/1ps
// ============================================================================
// 题目：事件计数跨时钟域
// 难度：★★★★☆☆
// 编号：05_cdc_reset/06_event_counter_cdc
//
// 要求：使用格雷计数器跨域并计算事件增量，说明允许的最大事件速率。
//
// 建议参数：WIDTH=8
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                src_clk
//   - input  1                src_rst_n
//   - input  1                src_event
//   - input  1                dst_clk
//   - input  1                dst_rst_n
//   - output WIDTH            event_count
//   - output WIDTH            event_delta
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=05_cdc_reset/06_event_counter_cdc；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module event_counter_cdc #(
    parameter integer WIDTH = 8
) (
    input wire src_clk,
    input wire src_rst_n,
    input wire src_event,
    input wire dst_clk,
    input wire dst_rst_n,
    output reg [WIDTH-1:0] event_count,
    output reg [WIDTH-1:0] event_delta
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
