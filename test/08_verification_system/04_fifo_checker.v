`timescale 1ns/1ps
// ============================================================================
// 题目：FIFO scoreboard 与断言
// 难度：★★★★☆☆
// 编号：08_verification_system/04_fifo_checker
//
// 要求：随机读写并检查顺序、满空边界、禁止溢出/下溢和指针合法性。
//
// 建议参数：WIDTH=8、DEPTH=16
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  1                wr_en
//   - input  WIDTH            wr_data
//   - input  1                rd_en
//   - input  WIDTH            rd_data
//   - input  1                full
//   - input  1                empty
//   - output 1                error
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=08_verification_system/04_fifo_checker；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module fifo_checker #(
    parameter integer WIDTH = 8,
    parameter integer DEPTH = 16
) (
    input wire clk,
    input wire rst_n,
    input wire wr_en,
    input wire [WIDTH-1:0] wr_data,
    input wire rd_en,
    input wire [WIDTH-1:0] rd_data,
    input wire full,
    input wire empty,
    output reg error
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
