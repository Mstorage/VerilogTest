`timescale 1ns/1ps
// ============================================================================
// 题目：无丢失 CDC 邮箱
// 难度：★★★★★☆
// 编号：05_cdc_reset/08_cdc_mailbox
//
// 要求：单条消息跨域传输，支持背压、复位中断和源/目的时钟暂停。
//
// 建议参数：WIDTH=32
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                src_clk
//   - input  1                src_rst_n
//   - input  1                src_valid
//   - output 1                src_ready
//   - input  WIDTH            src_data
//   - input  1                dst_clk
//   - input  1                dst_rst_n
//   - output 1                dst_valid
//   - input  1                dst_ready
//   - output WIDTH            dst_data
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=05_cdc_reset/08_cdc_mailbox；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module cdc_mailbox #(
    parameter integer WIDTH = 32
) (
    input wire src_clk,
    input wire src_rst_n,
    input wire src_valid,
    output reg src_ready,
    input wire [WIDTH-1:0] src_data,
    input wire dst_clk,
    input wire dst_rst_n,
    output reg dst_valid,
    input wire dst_ready,
    output reg [WIDTH-1:0] dst_data
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
