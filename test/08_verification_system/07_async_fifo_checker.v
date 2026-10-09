`timescale 1ns/1ps
// ============================================================================
// 题目：异步 FIFO 随机压力测试
// 难度：★★★★★☆
// 编号：08_verification_system/07_async_fifo_checker
//
// 要求：随机两个时钟、读写和复位，用队列参考模型检查数据完整性。
//
// 建议参数：WIDTH=8
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                wclk
//   - input  1                wrst_n
//   - input  1                w_en
//   - input  WIDTH            w_data
//   - input  1                w_full
//   - input  1                rclk
//   - input  1                rrst_n
//   - input  1                r_en
//   - input  WIDTH            r_data
//   - input  1                r_empty
//   - output 1                error
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=08_verification_system/07_async_fifo_checker；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module async_fifo_checker #(
    parameter integer WIDTH = 8
) (
    input wire wclk,
    input wire wrst_n,
    input wire w_en,
    input wire [WIDTH-1:0] w_data,
    input wire w_full,
    input wire rclk,
    input wire rrst_n,
    input wire r_en,
    input wire [WIDTH-1:0] r_data,
    input wire r_empty,
    output reg error
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
