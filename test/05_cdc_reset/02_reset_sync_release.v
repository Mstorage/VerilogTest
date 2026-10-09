`timescale 1ns/1ps
// ============================================================================
// 题目：异步复位同步释放
// 难度：★★☆☆☆☆
// 编号：05_cdc_reset/02_reset_sync_release
//
// 要求：复位可异步拉低、在各时钟域同步释放，避免恢复/移除时间问题。
//
// 建议参数：STAGES=2
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                async_rst_n
//   - output 1                sync_rst_n
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=05_cdc_reset/02_reset_sync_release；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module reset_sync_release #(
    parameter integer STAGES = 2
) (
    input wire clk,
    input wire async_rst_n,
    output reg sync_rst_n
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
