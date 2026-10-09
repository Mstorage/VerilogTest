`timescale 1ns/1ps
// ============================================================================
// 题目：工程化异步 FIFO
// 难度：★★★★★★
// 编号：04_fifo/08_async_fifo_engineering
//
// 要求：加入可配深度、almost 标志、复位恢复、随机异频验证与 CDC/断言检查。
//
// 建议参数：WIDTH=8、DEPTH=16、ADDR_WIDTH=4、ALMOST_MARGIN=2
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                wclk
//   - input  1                wrst_n
//   - input  1                w_en
//   - input  WIDTH            w_data
//   - output 1                w_full
//   - output 1                w_almost_full
//   - input  1                rclk
//   - input  1                rrst_n
//   - input  1                r_en
//   - output WIDTH            r_data
//   - output 1                r_empty
//   - output 1                r_almost_empty
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=04_fifo/08_async_fifo_engineering；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module async_fifo_engineering #(
    parameter integer WIDTH = 8,
    parameter integer DEPTH = 16,
    parameter integer ADDR_WIDTH = 4,
    parameter integer ALMOST_MARGIN = 2
) (
    input wire wclk,
    input wire wrst_n,
    input wire w_en,
    input wire [WIDTH-1:0] w_data,
    output reg w_full,
    output reg w_almost_full,
    input wire rclk,
    input wire rrst_n,
    input wire r_en,
    output reg [WIDTH-1:0] r_data,
    output reg r_empty,
    output reg r_almost_empty
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
