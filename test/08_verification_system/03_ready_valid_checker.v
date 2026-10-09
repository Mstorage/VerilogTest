`timescale 1ns/1ps
// ============================================================================
// 题目：Ready/Valid 协议断言
// 难度：★★★☆☆☆
// 编号：08_verification_system/03_ready_valid_checker
//
// 要求：检查背压时数据稳定、一次握手一次传输，以及无 X/Z 控制信号。
//
// 建议参数：WIDTH=8
// 端口列表（方向 / 位宽 / 名称）：
//   - input  1                clk
//   - input  1                rst_n
//   - input  1                valid
//   - input  1                ready
//   - input  WIDTH            data
//   - output 1                error
//
// 完成标准：
//   1. 补全下方可综合 RTL，并删除 TODO_IMPLEMENT 标记；
//   2. 不修改模块名及既有端口语义；
//   3. 执行 make run Q=08_verification_system/03_ready_valid_checker；
//   4. 通过后继续补充随机、边界与断言测试，基础测试不代表形式完备。
// ============================================================================

module ready_valid_checker #(
    parameter integer WIDTH = 8
) (
    input wire clk,
    input wire rst_n,
    input wire valid,
    input wire ready,
    input wire [WIDTH-1:0] data,
    output reg error
);

    // TODO_IMPLEMENT: 在此完成设计。

endmodule
