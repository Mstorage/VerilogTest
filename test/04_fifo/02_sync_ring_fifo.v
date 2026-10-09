`timescale 1ns/1ps
// ============================================================================
// 题目：同步环形 FIFO
// 难度：★★★☆☆☆
// 编号：04_fifo/02_sync_ring_fifo
//
// 要求：用读写指针和存储阵列实现，区分指针相等时的空与满。
//
// 建议参数：WIDTH=8、DEPTH=16、ADDR_WIDTH=4
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  1                wr_en
//   - input  WIDTH            wr_data
//   - input  1                rd_en
//   - output WIDTH            rd_data
//   - output 1                full
//   - output 1                empty
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=04_fifo/02_sync_ring_fifo；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module sync_ring_fifo #(
    parameter integer WIDTH = 8,
    parameter integer DEPTH = 16,
    parameter integer ADDR_WIDTH = 4
) (
    input wire clk,
    input wire rst_n,
    input wire wr_en,
    input wire [WIDTH-1:0] wr_data,
    input wire rd_en,
    output reg [WIDTH-1:0] rd_data,
    output reg full,
    output reg empty
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
