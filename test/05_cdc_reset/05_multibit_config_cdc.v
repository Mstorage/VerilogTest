`timescale 1ns/1ps
// ============================================================================
// 题目：多位配置总线 CDC
// 难度：★★★★☆☆
// 编号：05_cdc_reset/05_multibit_config_cdc
//
// 要求：使用数据保持 + 握手传输原子快照，禁止逐位两级同步。
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
//   - output WIDTH            dst_data
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=05_cdc_reset/05_multibit_config_cdc；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module multibit_config_cdc #(
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
    output reg [WIDTH-1:0] dst_data
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
