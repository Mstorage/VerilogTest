`timescale 1ns/1ps
// ============================================================================
// 题目：多通道虚拟 FIFO
// 难度：★★★★☆☆
// 编号：04_fifo/06_virtual_channel_fifo
//
// 要求：多个逻辑队列共享存储，维护各通道顺序、容量与公平调度。
//
// 建议参数：CHANNELS=4、WIDTH=8、DEPTH=16、CH_WIDTH=2
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  1                wr_en
//   - input  CH_WIDTH         wr_channel
//   - input  WIDTH            wr_data
//   - input  1                rd_en
//   - input  CH_WIDTH         rd_channel
//   - output WIDTH            rd_data
//   - output CHANNELS         full
//   - output CHANNELS         empty
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=04_fifo/06_virtual_channel_fifo；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module virtual_channel_fifo #(
    parameter integer CHANNELS = 4,
    parameter integer WIDTH = 8,
    parameter integer DEPTH = 16,
    parameter integer CH_WIDTH = 2
) (
    input wire clk,
    input wire rst_n,
    input wire wr_en,
    input wire [CH_WIDTH-1:0] wr_channel,
    input wire [WIDTH-1:0] wr_data,
    input wire rd_en,
    input wire [CH_WIDTH-1:0] rd_channel,
    output reg [WIDTH-1:0] rd_data,
    output reg [CHANNELS-1:0] full,
    output reg [CHANNELS-1:0] empty
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
