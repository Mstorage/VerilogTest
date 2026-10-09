`timescale 1ns/1ps
// ============================================================================
// 题目：非 2 次幂深度 FIFO
// 难度：★★★★☆☆
// 编号：04_fifo/05_non_power_of_two_fifo
//
// 要求：深度任意可配，显式处理地址回卷和指针宽度，避免越界访问。
//
// 建议参数：WIDTH=8、DEPTH=10、ADDR_WIDTH=4、COUNT_WIDTH=4
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  1                wr_en
//   - input  WIDTH            wr_data
//   - input  1                rd_en
//   - output WIDTH            rd_data
//   - output 1                full
//   - output 1                empty
//   - output COUNT_WIDTH      count
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=04_fifo/05_non_power_of_two_fifo；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module non_power_of_two_fifo #(
    parameter integer WIDTH = 8,
    parameter integer DEPTH = 10,
    parameter integer ADDR_WIDTH = 4,
    parameter integer COUNT_WIDTH = 4
) (
    input wire clk,
    input wire rst_n,
    input wire wr_en,
    input wire [WIDTH-1:0] wr_data,
    input wire rd_en,
    output reg [WIDTH-1:0] rd_data,
    output reg full,
    output reg empty,
    output reg [COUNT_WIDTH-1:0] count
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
