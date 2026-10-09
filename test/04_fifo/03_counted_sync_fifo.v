`timescale 1ns/1ps
// ============================================================================
// 题目：计数型同步 FIFO
// 难度：★★★☆☆☆
// 编号：04_fifo/03_counted_sync_fifo
//
// 要求：增加 `count/almost_full/almost_empty`，覆盖同周期读写及满/空边界。
//
// 建议参数：WIDTH=8、DEPTH=16、ADDR_WIDTH=4、COUNT_WIDTH=5、ALMOST_FULL=14、ALMOST_EMPTY=2
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  1                wr_en
//   - input  WIDTH            wr_data
//   - input  1                rd_en
//   - output WIDTH            rd_data
//   - output 1                full
//   - output 1                empty
//   - output 1                almost_full
//   - output 1                almost_empty
//   - output COUNT_WIDTH      count
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=04_fifo/03_counted_sync_fifo；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module counted_sync_fifo #(
    parameter integer WIDTH = 8,
    parameter integer DEPTH = 16,
    parameter integer ADDR_WIDTH = 4,
    parameter integer COUNT_WIDTH = 5,
    parameter integer ALMOST_FULL = 14,
    parameter integer ALMOST_EMPTY = 2
) (
    input wire clk,
    input wire rst_n,
    input wire wr_en,
    input wire [WIDTH-1:0] wr_data,
    input wire rd_en,
    output reg [WIDTH-1:0] rd_data,
    output reg full,
    output reg empty,
    output reg almost_full,
    output reg almost_empty,
    output reg [COUNT_WIDTH-1:0] count
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
