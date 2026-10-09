`timescale 1ns/1ps
// ============================================================================
// 题目：CDC 方案审查与修复
// 难度：★★★★★★
// 编号：05_cdc_reset/09_cdc_review_repair
//
// 要求：给定含脉冲、多位总线和重汇聚路径的错误 RTL，定位风险并逐类重构。
//
// 建议参数：WIDTH=16
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                src_clk
//   - input  1                src_rst_n
//   - input  1                src_level
//   - input  1                src_pulse
//   - input  WIDTH            src_bus
//   - input  1                src_bus_valid
//   - output 1                src_bus_ready
//   - input  1                dst_clk
//   - input  1                dst_rst_n
//   - output 1                dst_level
//   - output 1                dst_pulse
//   - output WIDTH            dst_bus
//   - output 1                dst_bus_valid
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=05_cdc_reset/09_cdc_review_repair；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module cdc_review_repair #(
    parameter integer WIDTH = 16
) (
    input wire src_clk,
    input wire src_rst_n,
    input wire src_level,
    input wire src_pulse,
    input wire [WIDTH-1:0] src_bus,
    input wire src_bus_valid,
    output reg src_bus_ready,
    input wire dst_clk,
    input wire dst_rst_n,
    output reg dst_level,
    output reg dst_pulse,
    output reg [WIDTH-1:0] dst_bus,
    output reg dst_bus_valid
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
